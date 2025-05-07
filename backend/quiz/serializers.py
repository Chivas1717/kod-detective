from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Language, Test, Question, UserProgress, TakenTest, UserProfile

class LanguageSerializer(serializers.ModelSerializer):
    class Meta:
        model = Language
        fields = ['id', 'name', 'code', 'icon']

class UserSerializer(serializers.ModelSerializer):
    score = serializers.IntegerField(source='profile.score', read_only=True)
    
    class Meta:
        model = User
        fields = ['id', 'username', 'score']
    
    def update(self, instance, validated_data):
        # Update user fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance

class TestSerializer(serializers.ModelSerializer):
    language_name = serializers.CharField(source='language.name', read_only=True)
    language_code = serializers.CharField(source='language.code', read_only=True)
    
    class Meta:
        model = Test
        fields = ['id', 'title', 'difficulty', 'language', 'language_name', 'language_code']

class QuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Question
        fields = ['id', 'type', 'prompt', 'hint', 'clue', 'metadata', 'correct_answer']

class AnswerItem(serializers.Serializer):
    question_id = serializers.IntegerField()
    answer = serializers.JSONField()

class SubmitAnswerSerializer(serializers.Serializer):
    answers = AnswerItem(many=True)

class UserProgressSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProgress
        fields = ['question', 'is_correct', 'attempts', 'time_spent', 'used_hint']

class TakenTestSerializer(serializers.ModelSerializer):
    test_title = serializers.CharField(source='test.title', read_only=True)
    test_difficulty = serializers.CharField(source='test.difficulty', read_only=True)
    language_name = serializers.CharField(source='test.language.name', read_only=True)
    language_code = serializers.CharField(source='test.language.code', read_only=True)
    
    class Meta:
        model = TakenTest
        fields = ['id', 'test', 'test_title', 'test_difficulty', 'language_name', 
                  'language_code', 'score_obtained', 'completed_at'] 