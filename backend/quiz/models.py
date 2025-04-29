from django.db import models
from django.contrib.auth.models import User
from django.utils import timezone

class Language(models.Model):
    name = models.CharField(max_length=50, unique=True)
    code = models.CharField(max_length=10, unique=True)  # e.g., 'py', 'js', 'java'
    icon = models.CharField(max_length=100, blank=True)  # Optional path to icon
    
    def __str__(self):
        return self.name

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile', null=True, blank=True)
    score = models.IntegerField(default=0)
    
    def __str__(self):
        return f"{self.user.username if self.user else 'No user'}'s profile"

class Test(models.Model):
    title = models.CharField(max_length=200, default="Untitled Test")
    difficulty = models.CharField(
        choices=[('easy','Легко'),('medium','Середньо'),('hard','Складно')], 
        max_length=10, 
        default='medium'
    )
    language = models.ForeignKey(Language, on_delete=models.CASCADE, related_name='tests', null=True, blank=True)
    
    def __str__(self):
        return f"{self.title} ({self.language.name if self.language else 'No language'})"

class Question(models.Model):
    test = models.ForeignKey(Test, related_name='questions', on_delete=models.CASCADE, null=True, blank=True)
    type = models.CharField(
        choices=[
            ('single','Single-choice'),
            ('blank','Fill-in-the-blank'),
            ('order','Code ordering'),
            ('trace','Code tracing'),
            ('debug','Debugging'),
        ], 
        max_length=10,
        default='single'
    )
    prompt = models.TextField(default="")
    hint = models.TextField(blank=True)  # Moved from Test to Question
    clue = models.TextField(blank=True)  # Moved from Test to Question
    metadata = models.JSONField(default=dict)  # Contains options, etc.
    correct_answer = models.JSONField(default=dict)  # Explicit field for correct answer
    
    def __str__(self):
        test_title = self.test.title if self.test else "No test"
        return f"Question {self.id} ({self.type}) - {test_title}"

class UserProgress(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='progress', null=True, blank=True)
    question = models.ForeignKey(Question, on_delete=models.CASCADE, related_name='user_progress', null=True, blank=True)
    is_correct = models.BooleanField(default=False)
    attempts = models.IntegerField(default=0)
    time_spent = models.IntegerField(default=0)  # in seconds
    used_hint = models.BooleanField(default=False)
    timestamp = models.DateTimeField(default=timezone.now)
    
    def __str__(self):
        user_name = self.user.username if self.user else "No user"
        question_id = self.question.id if self.question else "N/A"
        return f"{user_name}'s progress on question {question_id}"

class TakenTest(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='taken_tests', null=True, blank=True)
    test = models.ForeignKey(Test, on_delete=models.CASCADE, related_name='taken_by', null=True, blank=True)
    score_obtained = models.IntegerField(default=0)
    completed_at = models.DateTimeField(default=timezone.now)
    
    def __str__(self):
        user_name = self.user.username if self.user else "No user"
        test_title = self.test.title if self.test else "No test"
        return f"{user_name} took {test_title} on {self.completed_at}"
