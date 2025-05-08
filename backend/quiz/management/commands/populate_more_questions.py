from django.core.management.base import BaseCommand
from quiz.models import Language, Test, Question

class Command(BaseCommand):
    help = 'Наповнює базу даних додатковими тестами та питаннями'

    def handle(self, *args, **kwargs):
        # Отримання або створення мов
        js_language, _ = Language.objects.get_or_create(
            name='JavaScript',
            code='js',
            icon='js-icon.png'
        )
        
        python_language, created = Language.objects.get_or_create(
            name='Python',
            code='py',
            icon='python-icon.png'
        )
        
        if created:
            self.stdout.write(self.style.SUCCESS(f'Створено мову: {python_language.name}'))
        
        # Створення додаткових тестів для JavaScript
        js_tests = [
            Test.objects.create(
                title='JavaScript для початківців',
                difficulty='easy',
                language=js_language
            ),
            Test.objects.create(
                title='JavaScript DOM маніпуляції',
                difficulty='medium',
                language=js_language
            ),
            Test.objects.create(
                title='Асинхронний JavaScript',
                difficulty='medium',
                language=js_language
            ),
            Test.objects.create(
                title='JavaScript патерни проектування',
                difficulty='hard',
                language=js_language
            ),
            Test.objects.create(
                title='JavaScript функціональне програмування',
                difficulty='hard',
                language=js_language
            ),
        ]
        
        # Створення тестів для Python
        python_tests = [
            Test.objects.create(
                title='Основи Python',
                difficulty='easy',
                language=python_language
            ),
            Test.objects.create(
                title='Експертний Python',
                difficulty='hard',
                language=python_language
            ),
        ]
        
        # Наповнення тестів питаннями
        for test in js_tests:
            self.stdout.write(self.style.SUCCESS(f'Створено тест: {test.title}'))
            self._create_js_questions_for_test(test)
            
        for test in python_tests:
            self.stdout.write(self.style.SUCCESS(f'Створено тест: {test.title}'))
            self._create_python_questions_for_test(test)
            
        self.stdout.write(self.style.SUCCESS('Базу даних успішно наповнено додатковими питаннями!'))
    
    def _create_js_questions_for_test(self, test):
        # Питання для JavaScript тестів залежно від складності
        if test.difficulty == 'easy':
            self._create_easy_js_questions(test)
        elif test.difficulty == 'medium':
            self._create_medium_js_questions(test)
        else:  # hard
            self._create_hard_js_questions(test)
    
    def _create_python_questions_for_test(self, test):
        # Питання для Python тестів залежно від складності
        if test.difficulty == 'easy':
            self._create_easy_python_questions(test)
        else:  # hard
            self._create_hard_python_questions(test)
    
    def _create_easy_js_questions(self, test):
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Який оператор використовується для строгого порівняння в JavaScript?',
            hint='Цей оператор перевіряє як значення, так і тип даних',
            clue='Він складається з трьох символів',
            metadata={
                'options': [
                    {'id': 'a', 'text': '=='},
                    {'id': 'b', 'text': '==='},
                    {'id': 'c', 'text': '!='},
                    {'id': 'd', 'text': '>='}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Метод масиву, який додає елементи в кінець масиву, називається ____.',
            hint='Цей метод модифікує оригінальний масив',
            clue='Він "штовхає" елементи в масив',
            metadata={},
            correct_answer={'text': 'push'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб створити цикл, який виводить числа від 1 до 3:',
            hint='Використовуйте стандартний синтаксис циклу for',
            clue='Спочатку ініціалізація, потім умова, потім інкремент',
            metadata={
                'options': [
                    {'id': 1, 'text': 'for (let i = 1; i <= 3; i++) {'},
                    {'id': 2, 'text': '  console.log(i);'},
                    {'id': 3, 'text': '}'},
                    {'id': 4, 'text': 'console.log("Готово!");'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4]}
        )
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nlet text = "Hello";\ntext += " World";\nconsole.log(text);',
            hint='Оператор += конкатенує рядки',
            clue='Два слова об\'єднуються з пробілом між ними',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'Hello'},
                    {'id': 'b', 'text': 'World'},
                    {'id': 'c', 'text': 'Hello World'},
                    {'id': 'd', 'text': 'HelloWorld'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\nfunction greet(name) {\n  return "Привіт, " + name\n}\n\nlet result = greet();\nconsole.log(result);',
            hint='Функція очікує параметр, але він не передається',
            clue='Потрібно передати аргумент або встановити значення за замовчуванням',
            metadata={
                'originalCode': 'function greet(name) {\n  return "Привіт, " + name\n}\n\nlet result = greet();\nconsole.log(result);'
            },
            correct_answer={
                'correctedCode': 'function greet(name = "гість") {\n  return "Привіт, " + name\n}\n\nlet result = greet();\nconsole.log(result);'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}'))
    
    def _create_medium_js_questions(self, test):
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Який метод використовується для перетворення JSON-рядка в об\'єкт JavaScript?',
            hint='Цей метод є частиною вбудованого об\'єкта JSON',
            clue='Протилежний до JSON.stringify()',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'JSON.parse()'},
                    {'id': 'b', 'text': 'JSON.decode()'},
                    {'id': 'c', 'text': 'JSON.toObject()'},
                    {'id': 'd', 'text': 'JSON.deserialize()'}
                ]
            },
            correct_answer={'id': 'a'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Метод, який використовується для вибору DOM-елемента за його ID, називається ____.',
            hint='Цей метод є частиною об\'єкта document',
            clue='Він починається з "getElementById"',
            metadata={},
            correct_answer={'text': 'getElementById'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб додати обробник події кліку на кнопку:',
            hint='Спочатку отримайте елемент, потім додайте обробник',
            clue='Використовуйте addEventListener',
            metadata={
                'options': [
                    {'id': 1, 'text': 'const button = document.getElementById("myButton");'},
                    {'id': 2, 'text': 'button.addEventListener("click", function() {'},
                    {'id': 3, 'text': '  alert("Кнопку натиснуто!");'},
                    {'id': 4, 'text': '});'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4]}
        )
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nconst arr = [1, 2, 3, 4, 5];\nconst result = arr.filter(num => num % 2 === 0);\nconsole.log(result);',
            hint='Метод filter створює новий масив з елементів, що проходять тест',
            clue='Умова вибирає парні числа',
            metadata={
                'options': [
                    {'id': 'a', 'text': '[1, 3, 5]'},
                    {'id': 'b', 'text': '[2, 4]'},
                    {'id': 'c', 'text': '[1, 2, 3, 4, 5]'},
                    {'id': 'd', 'text': '[]'}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\ndocument.getElementById("myButton").addEventlistener("click", function() {\n  console.log("Кнопку натиснуто!");\n});',
            hint='Уважно перевірте назву методу addEventListener',
            clue='JavaScript чутливий до регістру',
            metadata={
                'originalCode': 'document.getElementById("myButton").addEventlistener("click", function() {\n  console.log("Кнопку натиснуто!");\n});'
            },
            correct_answer={
                'correctedCode': 'document.getElementById("myButton").addEventListener("click", function() {\n  console.log("Кнопку натиснуто!");\n});'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}'))
    
    def _create_hard_js_questions(self, test):
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Який патерн проектування використовується для створення об\'єктів без явного виклику конструктора?',
            hint='Цей патерн часто використовується в бібліотеках для створення об\'єктів',
            clue='Він "фабрикує" об\'єкти',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'Singleton'},
                    {'id': 'b', 'text': 'Observer'},
                    {'id': 'c', 'text': 'Factory'},
                    {'id': 'd', 'text': 'Decorator'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Функція, яка викликає сама себе, називається ____ функцією.',
            hint='Це важливий концепт у функціональному програмуванні',
            clue='Вона "повторює" себе',
            metadata={},
            correct_answer={'text': 'рекурсивною'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб створити Promise, який вирішується через 1 секунду:',
            hint='Використовуйте new Promise та setTimeout',
            clue='Спочатку створіть Promise, потім використовуйте setTimeout всередині',
            metadata={
                'options': [
                    {'id': 1, 'text': 'const myPromise = new Promise((resolve, reject) => {'},
                    {'id': 2, 'text': '  setTimeout(() => {'},
                    {'id': 3, 'text': '    resolve("Готово!");'},
                    {'id': 4, 'text': '  }, 1000);'},
                    {'id': 5, 'text': '});'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4, 5]}
        )
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nconst obj = {a: 1};\nconst copy = {...obj, b: 2};\nconsole.log(copy);',
            hint='Тут використовується оператор розширення (spread) для копіювання властивостей',
            clue='Новий об\'єкт містить всі властивості оригінального плюс нову властивість',
            metadata={
                'options': [
                    {'id': 'a', 'text': '{a: 1}'},
                    {'id': 'b', 'text': '{b: 2}'},
                    {'id': 'c', 'text': '{a: 1, b: 2}'},
                    {'id': 'd', 'text': '{}'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\nasync function fetchData() {\n  const response = await fetch("https://api.example.com/data");\n  const data = response.json();\n  return data;\n}',
            hint='Метод json() повертає Promise',
            clue='Потрібно дочекатися вирішення Promise від response.json()',
            metadata={
                'originalCode': 'async function fetchData() {\n  const response = await fetch("https://api.example.com/data");\n  const data = response.json();\n  return data;\n}'
            },
            correct_answer={
                'correctedCode': 'async function fetchData() {\n  const response = await fetch("https://api.example.com/data");\n  const data = await response.json();\n  return data;\n}'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}'))
    
    def _create_easy_python_questions(self, test):
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Яка функція використовується для виведення тексту в консоль у Python?',
            hint='Це одна з найбільш базових функцій у Python',
            clue='Вона "друкує" текст',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'console.log()'},
                    {'id': 'b', 'text': 'print()'},
                    {'id': 'c', 'text': 'echo()'},
                    {'id': 'd', 'text': 'write()'}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Структура даних, яка зберігає елементи у вигляді пар ключ-значення в Python, називається ____.',
            hint='Ця структура використовує фігурні дужки',
            clue='Вона схожа на об\'єкт у JavaScript',
            metadata={},
            correct_answer={'text': 'словник'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб створити функцію, яка повертає суму двох чисел:',
            hint='Використовуйте ключове слово def для оголошення функції',
            clue='Спочатку оголошення, потім тіло функції, потім виклик',
            metadata={
                'options': [
                    {'id': 1, 'text': 'def add_numbers(a, b):'},
                    {'id': 2, 'text': '    return a + b'},
                    {'id': 3, 'text': 'result = add_numbers(5, 3)'},
                    {'id': 4, 'text': 'print(result)'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4]}
        )
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nfruits = ["яблуко", "банан", "апельсин"]\nfruits.append("груша")\nprint(fruits[1])',
            hint='Індексація в Python починається з 0',
            clue='Елемент з індексом 1 - це другий елемент у списку',
            metadata={
                'options': [
                    {'id': 'a', 'text': 'яблуко'},
                    {'id': 'b', 'text': 'банан'},
                    {'id': 'c', 'text': 'апельсин'},
                    {'id': 'd', 'text': 'груша'}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\ndef calculate_average(numbers):\n  total = 0\n  for num in numbers:\n    total += num\n  return total / len(numbers)\n\nresult = calculate_average([])\nprint(result)',
            hint='Що станеться при діленні на довжину порожнього списку?',
            clue='Потрібно перевірити, чи не порожній список',
            metadata={
                'originalCode': 'def calculate_average(numbers):\n  total = 0\n  for num in numbers:\n    total += num\n  return total / len(numbers)\n\nresult = calculate_average([])\nprint(result)'
            },
            correct_answer={
                'correctedCode': 'def calculate_average(numbers):\n  if not numbers:\n    return 0\n  total = 0\n  for num in numbers:\n    total += num\n  return total / len(numbers)\n\nresult = calculate_average([])\nprint(result)'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}'))
    
    def _create_hard_python_questions(self, test):
        # Питання з одним варіантом відповіді
        Question.objects.create(
            test=test,
            type='single',
            prompt='Який декоратор використовується для створення методу властивості в Python?',
            hint='Цей декоратор дозволяє викликати метод як атрибут',
            clue='Він перетворює метод на "властивість"',
            metadata={
                'options': [
                    {'id': 'a', 'text': '@staticmethod'},
                    {'id': 'b', 'text': '@classmethod'},
                    {'id': 'c', 'text': '@property'},
                    {'id': 'd', 'text': '@decorator'}
                ]
            },
            correct_answer={'id': 'c'}
        )
        
        # Питання з заповненням пропуску
        Question.objects.create(
            test=test,
            type='blank',
            prompt='Спеціальний метод __init__ в класі Python називається ____.',
            hint='Цей метод викликається при створенні нового екземпляра класу',
            clue='Він "конструює" об\'єкт',
            metadata={},
            correct_answer={'text': 'конструктором'}
        )
        
        # Питання з упорядкуванням коду
        Question.objects.create(
            test=test,
            type='order',
            prompt='Розташуйте ці рядки коду, щоб створити генератор, який повертає квадрати чисел:',
            hint='Використовуйте ключове слово yield',
            clue='Спочатку оголошення функції, потім цикл з yield',
            metadata={
                'options': [
                    {'id': 1, 'text': 'def squares(n):'},
                    {'id': 2, 'text': '    for i in range(n):'},
                    {'id': 3, 'text': '        yield i * i'},
                    {'id': 4, 'text': 'for square in squares(5):'},
                    {'id': 5, 'text': '    print(square)'}
                ]
            },
            correct_answer={'order': [1, 2, 3, 4, 5]}
        )
        
        # Питання з трасуванням коду
        Question.objects.create(
            test=test,
            type='trace',
            prompt='Що буде виведено в результаті виконання цього коду?\n\nclass A:\n    x = 1\n\nclass B(A):\n    pass\n\nclass C(A):\n    x = 2\n\nprint(B().x, C().x)',
            hint='Тут використовується наслідування класів',
            clue='Клас B наслідує x від A, а клас C перевизначає x',
            metadata={
                'options': [
                    {'id': 'a', 'text': '1 1'},
                    {'id': 'b', 'text': '1 2'},
                    {'id': 'c', 'text': '2 2'},
                    {'id': 'd', 'text': '2 1'}
                ]
            },
            correct_answer={'id': 'b'}
        )
        
        # Питання з налагодженням
        Question.objects.create(
            test=test,
            type='debug',
            prompt='Виправте помилку в цьому коді:\n\nfrom threading import Thread\n\ndef worker():\n    print("Робота виконується")\n\nthreads = []\nfor i in range(5):\n    t = Thread(target=worker)\n    threads.append(t)\n\nfor t in threads:\n    t.start()\n\nprint("Всі потоки запущено")',
            hint='Потоки виконуються асинхронно, але основний потік може завершитися раніше',
            clue='Потрібно дочекатися завершення всіх потоків',
            metadata={
                'originalCode': 'from threading import Thread\n\ndef worker():\n    print("Робота виконується")\n\nthreads = []\nfor i in range(5):\n    t = Thread(target=worker)\n    threads.append(t)\n\nfor t in threads:\n    t.start()\n\nprint("Всі потоки запущено")'
            },
            correct_answer={
                'correctedCode': 'from threading import Thread\n\ndef worker():\n    print("Робота виконується")\n\nthreads = []\nfor i in range(5):\n    t = Thread(target=worker)\n    threads.append(t)\n\nfor t in threads:\n    t.start()\n\nfor t in threads:\n    t.join()\n\nprint("Всі потоки запущено")'
            }
        )
        
        self.stdout.write(self.style.SUCCESS(f'  Створено 5 питань для тесту: {test.title}')) 