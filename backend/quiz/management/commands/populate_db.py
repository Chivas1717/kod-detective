from django.core.management.base import BaseCommand
from quiz.models import Language, Test, Question, UserProfile
from django.contrib.auth.models import User

class Command(BaseCommand):
    help = 'Наповнює базу даних прикладами для тестування'

    def handle(self, *args, **kwargs):
        # Створення мови JavaScript
        js_language, created = Language.objects.get_or_create(
            name='JavaScript',
            code='js',
            icon='js-icon.png'
        )
        self.stdout.write(self.style.SUCCESS(f'Створено мову: {js_language.name}'))

        # Створення трьох тестів з різними рівнями складності
        tests = [
            Test.objects.create(
                title='Основи JavaScript',
                difficulty='easy',
                language=js_language
            ),
            Test.objects.create(
                title='Розширені концепції JavaScript',
                difficulty='medium',
                language=js_language
            ),
            Test.objects.create(
                title='Експертний виклик TypeScript',
                difficulty='hard',
                language=js_language
            )
        ]
        
        for test in tests:
            self.stdout.write(self.style.SUCCESS(f'Створено тест: {test.title}'))
            
            # Створення питань для кожного тесту
            self._create_questions_for_test(test)
            
        self.stdout.write(self.style.SUCCESS('Базу даних успішно наповнено!'))
    
    def _create_questions_for_test(self, test):
        # Створення одного питання кожного типу
        
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Яке ключове слово використовується для оголошення змінної з областю видимості блока в JavaScript?',
            hint='Подумайте про ключові слова для оголошення змінних, введені в ES6',
            clue='Воно починається з літери "l"',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'var'},
                    {'id': 'b', 'text': 'const'},
                    {'id': 'c', 'text': 'let'},
                    {'id': 'd', 'text': 'function'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Заповніть пропуск: Щоб звернутися до властивості об\'єкта в JavaScript, ви використовуєте ____ нотацію або ____ нотацію.',
            hint='Існує два способи доступу до властивостей об\'єкта',
            clue='Одна з них використовує крапку',
            metadata={},
            correct_answer={'text': 'крапкову, квадратних дужок'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб створити функцію, яка повертає квадрат числа:',
            hint='Подумайте про правильний синтаксис оголошення функції',
            clue='Почніть з ключового слова function',
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
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nlet x = 1;\nlet y = 2;\n[x, y] = [y, x];\nconsole.log(x, y);',
            hint='Тут використовується деструктуризація масиву для обміну значеннями',
            clue='Подумайте, що відбувається зі змінними після обміну',
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
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\nfunction sum(a, b) {\n  return a + b\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);',
            hint='Подумайте про перетворення типів при роботі з різними типами даних',
            clue='Вам потрібно перетворити рядок на число',
            metadata={
                'originalCode': 'function sum(a, b) {\n  return a + b\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);'
            },
            correct_answer={
                'correctedCode': 'function sum(a, b) {\n  return a + Number(b)\n}\n\nconst result = sum(5, "10");\nconsole.log(result * 2);'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}'))
