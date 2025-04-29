from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from rest_framework import status
from rest_framework.views import APIView
from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny
from django.db import IntegrityError

class CustomAuthToken(ObtainAuthToken):
    """
    Get auth token for existing user
    """
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid():
            user = serializer.validated_data['user']
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'token': token.key,
                'user_id': user.pk,
                'username': user.username
            })
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class RegisterView(APIView):
    """
    Register a new user
    """
    permission_classes = [AllowAny]
    
    def post(self, request):
        username = request.data.get('username')
        password = request.data.get('password')
        email = request.data.get('email', '')
        
        if not username or not password:
            return Response(
                {"error": "Username and password are required"},
                status=status.HTTP_400_BAD_REQUEST
            )
            
        try:
            user = User.objects.create_user(
                username=username,
                password=password,
                email=email
            )
            
            # Create token for the new user
            token, created = Token.objects.get_or_create(user=user)
            
            return Response({
                "message": "User registered successfully",
                "token": token.key,
                "user_id": user.pk,
                "username": user.username
            }, status=status.HTTP_201_CREATED)
            
        except IntegrityError:
            return Response(
                {"error": "Username already exists"},
                status=status.HTTP_400_BAD_REQUEST
            ) 