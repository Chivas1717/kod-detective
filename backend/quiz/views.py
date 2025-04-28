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
                    correct_answer = question.metadata.get('correct_answer')
                    
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
