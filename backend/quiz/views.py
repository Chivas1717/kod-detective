from django.shortcuts import render, get_object_or_404
from django.contrib.auth.models import User
from django.db.models import Sum
from rest_framework import viewsets, generics, status
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from .models import Language, Test, Question, UserProgress, TakenTest, UserProfile
from .serializers import (
    UserSerializer, LanguageSerializer, TestSerializer, QuestionSerializer,
    SubmitAnswerSerializer, UserProgressSerializer, TakenTestSerializer
)

# Create your views here. 

# Add a try-except around the import
try:
    from .services import ChatService
except ImportError:
    # Create a dummy ChatService for testing
    class ChatService:
        def __init__(self, *args, **kwargs):
            pass
        
        def get_response(self, *args, **kwargs):
            return "AI assistance is not available. Please install the requests library."

# Add a view for languages
class LanguageViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint that allows programming languages to be viewed.
    """
    queryset = Language.objects.all()
    serializer_class = LanguageSerializer

class LeaderboardView(generics.ListAPIView):
    """
    API endpoint that returns users sorted by their score in descending order.
    """
    queryset = User.objects.all().order_by('-profile__score')
    serializer_class = UserSerializer

class TestViewSet(viewsets.ReadOnlyModelViewSet):
    """
    API endpoint that allows tests to be viewed.
    """
    queryset = Test.objects.all()
    serializer_class = TestSerializer
    
    def get_queryset(self):
        queryset = Test.objects.all()
        
        # Filter by language if provided
        language_id = self.request.query_params.get('language_id')
        language_code = self.request.query_params.get('language_code')
        
        if language_id:
            queryset = queryset.filter(language_id=language_id)
        elif language_code:
            queryset = queryset.filter(language__code=language_code)
            
        return queryset

class TestQuestionsView(generics.ListAPIView):
    """
    API endpoint that returns all questions for a specific test.
    """
    serializer_class = QuestionSerializer
    
    def get_queryset(self):
        test_id = self.kwargs['test_id']
        return Question.objects.filter(test_id=test_id)

class SubmitAnswersView(APIView):
    """
    API endpoint for submitting answers to a test.
    """
    permission_classes = [IsAuthenticated]
    
    def post(self, request, test_id):
        test = get_object_or_404(Test, pk=test_id)
        serializer = SubmitAnswerSerializer(data=request.data)
        
        if serializer.is_valid():
            answers = serializer.validated_data['answers']
            user = request.user
            
            # Get difficulty multiplier
            difficulty_multiplier = {
                'easy': 1,
                'medium': 2,
                'hard': 3
            }.get(test.difficulty, 1)
            
            total_score = 0
            correct_answers = 0
            
            # Process each answer
            for answer_data in answers:
                question_id = answer_data['question_id']
                submitted_answer = answer_data['answer']
                
                try:
                    question = Question.objects.get(pk=question_id, test=test)
                    correct_answer = question.correct_answer  # Use the dedicated field
                    
                    # Check if answer is correct
                    is_correct = submitted_answer == correct_answer
                    
                    # Create or update UserProgress
                    progress, created = UserProgress.objects.get_or_create(
                        user=user,
                        question=question,
                        defaults={
                            'is_correct': is_correct,
                            'attempts': 1,
                            'time_spent': request.data.get('time_spent', 0),
                            'used_hint': request.data.get('used_hint', False)
                        }
                    )
                    
                    if not created:
                        progress.attempts += 1
                        progress.is_correct = is_correct
                        progress.save()
                    
                    if is_correct:
                        correct_answers += 1
                        
                except Question.DoesNotExist:
                    return Response(
                        {"error": f"Question with id {question_id} does not exist in this test"},
                        status=status.HTTP_400_BAD_REQUEST
                    )
            
            # Calculate score
            total_score = correct_answers * difficulty_multiplier
            
            # Update user's total score
            profile, created = UserProfile.objects.get_or_create(user=user)
            profile.score += total_score
            profile.save()
            
            # Create TakenTest record
            TakenTest.objects.create(
                user=user,
                test=test,
                score_obtained=total_score
            )
            
            return Response({
                "message": "Answers submitted successfully",
                "correct_answers": correct_answers,
                "total_questions": len(answers),
                "score_obtained": total_score,
                "total_score": profile.score
            })
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class QuestionAIAssistantView(APIView):
    """
    API endpoint for getting AI assistance with a specific question
    """
    permission_classes = [IsAuthenticated]
    
    def post(self, request, question_id=None):
        # Get the user's prompt from request data
        user_prompt = request.data.get('prompt', '')
        
        if not user_prompt:
            return Response(
                {"error": "Please provide a prompt"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Option 1: Get question by ID if provided in URL
        if question_id:
            question = get_object_or_404(Question, pk=question_id)
            question_data = {
                'id': question.id,
                'prompt': question.prompt,
                'type': question.type,
                'correct_answer': question.correct_answer,
                'hint': question.hint,
                'clue': question.clue,
                'metadata': question.metadata
            }
            
            # Initialize the chat service and get response with question context
            chat_service = ChatService()
            ai_response = chat_service.get_response(user_prompt, question_data)
        # Option 2: Get question from request data
        else:
            question_data = request.data.get('question', {})
            if question_data:
                # If question data is provided, use it for context
                chat_service = ChatService()
                ai_response = chat_service.get_response(user_prompt, question_data)
            else:
                # Handle general programming questions without question context
                chat_service = ChatService()
                ai_response = chat_service.get_general_response(user_prompt)
        
        # Return response
        return Response({
            'response': ai_response
        })

class AllQuestionsView(generics.ListAPIView):
    """
    API endpoint to retrieve all questions in the application
    """
    queryset = Question.objects.all()
    serializer_class = QuestionSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """
        Optionally filter questions by language_id or type
        """
        queryset = Question.objects.all()
        
        # Filter by language if provided
        language_id = self.request.query_params.get('language_id')
        if language_id:
            queryset = queryset.filter(test__language_id=language_id)
            
        # Filter by question type if provided
        question_type = self.request.query_params.get('type')
        if question_type:
            queryset = queryset.filter(type=question_type)
            
        return queryset

class UserProfileView(APIView):
    """
    API endpoint for retrieving and updating the current user's profile
    """
    permission_classes = [IsAuthenticated]
    
    def get(self, request):
        """Get the current user's profile information"""
        user = request.user
        # Include the user's profile data in the serialized response
        serializer = UserSerializer(user)
        return Response(serializer.data)

class UserUpdateView(APIView):
    """
    API endpoint for updating user profile information
    """
    permission_classes = [IsAuthenticated]
    
    def patch(self, request):
        """Update the user's username and/or status"""
        user = request.user
        username = request.data.get('username')
        
        # Update username if provided and not already taken
        if username and username != user.username:
            if User.objects.filter(username=username).exclude(id=user.id).exists():
                return Response(
                    {"error": "Username already exists"},
                    status=status.HTTP_400_BAD_REQUEST
                )
            user.username = username
            user.save()
        
        # Return the updated user data
        serializer = UserSerializer(user)
        return Response(serializer.data)
