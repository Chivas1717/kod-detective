from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    LeaderboardView, LanguageViewSet, TestViewSet, TestQuestionsView, 
    SubmitAnswersView, QuestionAIAssistantView, AllQuestionsView,
    UserProfileView, UserUpdateView, CompletedTestsView, OtherUserProfileView
)
from .auth import CustomAuthToken, RegisterView

router = DefaultRouter()
router.register(r'languages', LanguageViewSet)
router.register(r'tests', TestViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('auth/login/', CustomAuthToken.as_view(), name='api_token_auth'),
    path('auth/register/', RegisterView.as_view(), name='register'),
    path('leaderboard/', LeaderboardView.as_view(), name='leaderboard'),
    path('tests/<int:test_id>/questions/', TestQuestionsView.as_view(), name='test-questions'),
    path('questions/', AllQuestionsView.as_view(), name='all-questions'),
    path('tests/<int:test_id>/submit/', SubmitAnswersView.as_view(), name='submit-answers'),
    path('questions/<int:question_id>/ask/', QuestionAIAssistantView.as_view(), name='question-assistant'),
    path('ask/', QuestionAIAssistantView.as_view(), name='general-assistant'),
    path('users/self/', UserProfileView.as_view(), name='user-profile'),
    path('users/<int:user_id>/', OtherUserProfileView.as_view(), name='other-user-profile'),
    path('users/update/', UserUpdateView.as_view(), name='update-user'),
    path('completed-tests/', CompletedTestsView.as_view(), name='completed-tests'),
    path('users/<int:user_id>/completed-tests/', CompletedTestsView.as_view(), name='user-completed-tests'),
] 