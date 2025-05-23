# Generated by Django 4.2.20 on 2025-04-28 14:23

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion
import django.utils.timezone


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('quiz', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Language',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, unique=True)),
                ('code', models.CharField(max_length=10, unique=True)),
                ('icon', models.CharField(blank=True, max_length=100)),
            ],
        ),
        migrations.AddField(
            model_name='userprogress',
            name='attempts',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='is_correct',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='question',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='user_progress', to='quiz.question'),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='time_spent',
            field=models.IntegerField(default=0),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='timestamp',
            field=models.DateTimeField(default=django.utils.timezone.now),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='used_hint',
            field=models.BooleanField(default=False),
        ),
        migrations.AddField(
            model_name='userprogress',
            name='user',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='progress', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AlterField(
            model_name='question',
            name='prompt',
            field=models.TextField(default=''),
        ),
        migrations.AlterField(
            model_name='question',
            name='test',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='questions', to='quiz.test'),
        ),
        migrations.AlterField(
            model_name='question',
            name='type',
            field=models.CharField(choices=[('single', 'Single-choice'), ('blank', 'Fill-in-the-blank'), ('order', 'Code ordering'), ('trace', 'Code tracing'), ('debug', 'Debugging')], default='single', max_length=10),
        ),
        migrations.AlterField(
            model_name='test',
            name='difficulty',
            field=models.CharField(choices=[('easy', 'Легко'), ('medium', 'Середньо'), ('hard', 'Складно')], default='medium', max_length=10),
        ),
        migrations.AlterField(
            model_name='test',
            name='title',
            field=models.CharField(default='Untitled Test', max_length=200),
        ),
        migrations.CreateModel(
            name='UserProfile',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('score', models.IntegerField(default=0)),
                ('user', models.OneToOneField(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='profile', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='TakenTest',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('score_obtained', models.IntegerField(default=0)),
                ('completed_at', models.DateTimeField(default=django.utils.timezone.now)),
                ('test', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='taken_by', to='quiz.test')),
                ('user', models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='taken_tests', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.AddField(
            model_name='test',
            name='language',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.CASCADE, related_name='tests', to='quiz.language'),
        ),
    ]
