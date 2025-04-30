from django.core.management.base import BaseCommand
import subprocess
import sys

class Command(BaseCommand):
    help = 'Dumps the database data excluding user data'

    def handle(self, *args, **kwargs):
        try:
            # Dump all models except for auth.User, authtoken, and admin models
            cmd = [
                'python', 'manage.py', 'dumpdata',
                'quiz.Language', 'quiz.Test', 'quiz.Question', 'quiz.UserProfile',
                'quiz.UserProgress', 'quiz.TakenTest',
                '--indent', '4',
                '--output', 'quiz_data_dump.json'
            ]
            
            subprocess.run(cmd, check=True)
            self.stdout.write(self.style.SUCCESS('Successfully dumped quiz data to quiz_data_dump.json'))
            
        except subprocess.CalledProcessError as e:
            self.stdout.write(self.style.ERROR(f'Error dumping data: {e}'))
            sys.exit(1)
