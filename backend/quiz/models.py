from django.db import models

class Test(models.Model):
    title      = models.CharField(max_length=200)
    difficulty = models.CharField(choices=[('easy','Легко'),('medium','Середньо'),('hard','Складно')], max_length=10)
    hint       = models.TextField(blank=True)
    clue       = models.TextField(blank=True)

class Question(models.Model):
    test     = models.ForeignKey(Test, related_name='questions', on_delete=models.CASCADE)
    type     = models.CharField(choices=[
        ('single','Single-choice'),
        ('blank','Fill-in-the-blank'),
        ('order','Code ordering'),
        ('trace','Code tracing'),
        ('debug','Debugging'),
    ], max_length=10)
    prompt   = models.TextField()
    metadata = models.JSONField(default=dict)

class UserProgress(models.Model):
    # …
    pass
