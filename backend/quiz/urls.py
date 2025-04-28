from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import LeaderboardView, LanguageViewSet, TestViewSet, TestQuestionsView, SubmitAnswersView

router = DefaultRouter()
router.register(r'languages', LanguageViewSet)
router.register(r'tests', TestViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('leaderboard/', LeaderboardView.as_view(), name='leaderboard'),
    path('tests/<int:test_id>/questions/', TestQuestionsView.as_view(), name='test-questions'),
    path('tests/<int:test_id>/submit/', SubmitAnswersView.as_view(), name='submit-answers'),
] 