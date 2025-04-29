import requests
import json

class ChatService:
    """Service for interacting with Ollama API for AI responses"""
    
    def __init__(self, base_url="http://localhost:11434", model="llama3:8b"):
        self.base_url = base_url
        self.model = model
        self.api_endpoint = f"{self.base_url}/api/generate"
    
    def get_response(self, user_prompt, question_data):
        """
        Get AI response for a user's prompt about a specific question
        
        Args:
            user_prompt: The user's specific question or prompt
            question_data: Full question object with all details
        """
        # Format options for better context if they exist
        options_text = ""
        if question_data.get('metadata', {}).get('options'):
            options = question_data.get('metadata', {}).get('options', [])
            options_text = "\nOptions:\n"
            for option in options:
                option_id = option.get('id', '')
                option_text = option.get('text', '')
                options_text += f"  {option_id}. {option_text}\n"
        
        # Format the prompt with all available context
        prompt = f"""
        You are a helpful programming tutor. The user is asking about this quiz question:
        
        Question ID: {question_data.get('id', 'Unknown')}
        Type: {question_data.get('type', 'Unknown')}
        Question: {question_data.get('prompt', '')}
        {options_text}
        
        User's prompt: {user_prompt}
        
        Provide a helpful explanation that guides the user toward understanding without directly revealing the answer.
        Offer hints and conceptual explanations rather than telling them exactly what to choose or type.
        If the question is code-related, explain the relevant concepts and patterns.
        """
        
        return self._make_request(prompt)
    
    def get_general_response(self, user_prompt):
        """
        Get AI response for a general programming question not tied to any specific quiz question
        
        Args:
            user_prompt: The user's programming question
        """
        prompt = f"""
        You are a helpful programming tutor. The user has asked you a general question about programming:
        
        User's question: {user_prompt}
        
        Provide a clear and informative explanation that helps the user understand the concept.
        Include code examples where appropriate to illustrate your explanation.
        """
        
        return self._make_request(prompt)
    
    def _make_request(self, prompt):
        """
        Make a request to the Ollama API
        
        Args:
            prompt: The formatted prompt to send
        """
        response = requests.post(
            self.api_endpoint,
            json={
                "model": self.model,
                "prompt": prompt,
                "stream": False
            }
        )
        
        if response.status_code == 200:
            return response.json().get("response", "Sorry, I couldn't generate a response.")
        else:
            return f"Sorry, there was an error generating a response. Status code: {response.status_code}" 