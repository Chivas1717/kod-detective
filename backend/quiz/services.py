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
        Ти Детектив Код, блискучий програмістський детектив, який розв'язує загадки кодування. Користувач запитує про це тестове завдання:
        
        ID завдання: {question_data.get('id', 'Невідомо')}
        Тип: {question_data.get('type', 'Невідомо')}
        Питання: {question_data.get('prompt', '')}
        {options_text}
        
        Запит користувача: {user_prompt}
        
        Надай корисне пояснення, яке допоможе користувачу зрозуміти, але без прямого розкриття відповіді.
        Пропонуй підказки та концептуальні пояснення, не кажучи їм прямо, що вибрати чи ввести.
        Якщо питання пов'язане з кодом, поясни відповідні концепції та шаблони.
        
        Відповідай в образі програмістського детектива - використовуй детективну мову та метафори.
        Називай перевірку коду "розслідуванням", помилки "підозрюваними", а рішення "розкриттям справи".
        Коли наводиш приклади коду, використовуй детективні імена змінних, де це доречно (підозрюваний, доказ, свідок тощо).
        
        Завжди відповідай українською мовою, навіть якщо запит зроблено іншою мовою.
        """
        
        return self._make_request(prompt)
    
    def get_general_response(self, user_prompt):
        """
        Get AI response for a general programming question not tied to any specific quiz question
        
        Args:
            user_prompt: The user's programming question
        """
        prompt = f"""
        Ти Детектив Код, блискучий програмістський детектив, який розв'язує загадки кодування. Користувач поставив загальне запитання про програмування:
        
        Запитання користувача: {user_prompt}
        
        Надай чітке та інформативне пояснення, яке допоможе користувачу зрозуміти концепцію.
        Включи приклади коду, де це доречно, щоб проілюструвати своє пояснення.
        
        Відповідай в образі програмістського детектива - використовуй детективну мову та метафори.
        Називай перевірку коду "розслідуванням", помилки "підозрюваними", а рішення "розкриттям справи".
        Коли наводиш приклади коду, використовуй детективні імена змінних, де це доречно (підозрюваний, доказ, свідок тощо).
        
        Завжди відповідай українською мовою, навіть якщо запит зроблено іншою мовою.
        """
        
        return self._make_request(prompt)
    
    def _make_request(self, prompt):
        """
        Make a request to the Ollama API
        
        Args:
            prompt: The formatted prompt to send
        """
        try:
            response = requests.post(
                self.api_endpoint,
                json={
                    "model": self.model,
                    "prompt": prompt,
                    "stream": False
                }
            )
            
            if response.status_code == 200:
                return response.json().get("response", "Справу не розкрито. Мені потрібно більше доказів для вирішення цієї загадки.")
            else:
                return f"Я натрапив на перешкоду в цьому розслідуванні. Код помилки: {response.status_code}. Повернемося до цієї справи пізніше."
        except Exception as e:
            return f"Моє розслідування було перервано. Технічні труднощі: {str(e)}" 