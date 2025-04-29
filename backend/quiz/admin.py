from django.contrib import admin
from .models import UserProfile, Language, Test, Question, UserProgress, TakenTest

@admin.register(Language)
class LanguageAdmin(admin.ModelAdmin):
    list_display = ('name', 'code')
    search_fields = ('name', 'code')

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'score')
    search_fields = ('user__username',)

@admin.register(Test)
class TestAdmin(admin.ModelAdmin):
    list_display = ('title', 'language', 'difficulty')
    list_filter = ('difficulty', 'language')
    search_fields = ('title',)

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'test', 'type', 'prompt_preview')
    list_filter = ('test', 'type', 'test__language')
    search_fields = ('prompt', 'hint', 'clue')
    
    def prompt_preview(self, obj):
        return obj.prompt[:50] + '...' if len(obj.prompt) > 50 else obj.prompt
    
    prompt_preview.short_description = 'Prompt Preview'

@admin.register(UserProgress)
class UserProgressAdmin(admin.ModelAdmin):
    list_display = ('user', 'question', 'is_correct', 'attempts', 'timestamp')
    list_filter = ('is_correct', 'used_hint', 'question__test__language')
    search_fields = ('user__username',)

@admin.register(TakenTest)
class TakenTestAdmin(admin.ModelAdmin):
    list_display = ('user', 'test', 'score_obtained', 'completed_at')
    list_filter = ('test', 'completed_at', 'test__language')
    search_fields = ('user__username', 'test__title')
