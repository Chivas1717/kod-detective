from django.core.management.base import BaseCommand
from quiz.models import Language, Test, Question, UserProfile
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Populates the database with sample data for testing'

    def handle(self, *args, **kwargs):
        # Create JavaScript language
        js_language, created = Language.objects.get_or_create(
            name='JavaScript',
            code='js',
            icon='js-icon.png'
        )
        self.stdout.write(self.style.SUCCESS(f'Created language: {js_language.name}'))

        # Create three tests with different difficulty levels
        tests = [
            Test.objects.create(
                title='JavaScript Basics',
                difficulty='easy',
                language=js_language
            ),
            Test.objects.create(
                title='JavaScript Advanced Concepts',
                difficulty='medium',
                language=js_language
            ),
            Test.objects.create(
                title='TypeScript Expert Challenge',
                difficulty='hard',
                language=js_language
            )
        ]
        
        for test in tests:
            self.stdout.write(self.style.SUCCESS(f'Created test: {test.title}'))
            
            # Create questions for each test
            self._create_questions_for_test(test)
            
        self.stdout.write(self.style.SUCCESS('Database populated successfully!'))
    
    def _create_questions_for_test(self, test):
        # Create one question of each type
        
        # Single-choice question
        Question.objects.create(
            test=test,
            type='single',
            prompt='What is the correct way to declare a variable in JavaScript that cannot be reassigned?',
            hint='Think about variable declaration keywords introduced in ES6',
            clue='It starts with "c"',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'var x = 5;'},
                    {'id': 'b', 'text': 'let x = 5;'},
                    {'id': 'c', 'text': 'const x = 5;'},
                    {'id': 'd', 'text': 'static x = 5;'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Fill-in-the-blank question
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Complete the code to log "Hello World" to the console:\n\nconsole.___("Hello World");',
            hint='This is the most common console method for output',
            clue='It\'s a method that starts with "l"',
            metadata={
                'placeholder': 'Type your answer here'
            },
            correct_answer={'text': 'log'}
        )
        
        # Code ordering question
        Question.objects.create(
            test=test,
            type='order',
            prompt='Arrange these lines of code to create a function that returns the square of a number:',
            hint='Think about the correct syntax for a function declaration',
            clue='Start with the function keyword',
            metadata={
                'options': [
                    {'id': 1, 'text': 'function square(x) {'},
                    {'id': 2, 'text': '  return x * x;'},
                    {'id': 3, 'text': '}'},
                    {'id': 4, 'text': 'console.log(square(5));'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4]}
        )
        
        # Code tracing question
        Question.objects.create(
            test=test,
            type='trace',
            prompt='What will be the output of this code?\n\nlet x = 1;\nlet y = 2;\n[x, y] = [y, x];\nconsole.log(x, y);',
            hint='This is using array destructuring to swap values',
            clue='Think about what happens to the variables after the swap',
            metadata={
                'options': [
                    {'id': 'a', 'text': '1 2'},
                    {'id': 'b', 'text': '2 1'},
                    {'id': 'c', 'text': '1 1'},
                    {'id': 'd', 'text': '2 2'}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Debugging question
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Fix the error in this code:\n\nfunction sum(a, b) {\n  return a + b\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);',
            hint='Think about type conversion when working with different types',
            clue='You need to convert the string to a number',
            metadata={
                'originalCode': 'function sum(a, b) {\n  return a + b\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);'
            },
            correct_answer={
                'correctedCode': 'function sum(a, b) {\n  return a + Number(b)\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Created 5 questions for test: {test.title}'))
