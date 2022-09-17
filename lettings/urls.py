from django.urls import path

from lettings.views import index, letting

app_name = 'lettings'

urlpatterns = [
    path('lettings/', index, name='index'),
    path('lettings/<int:letting_id>/', letting, name='letting'),
]
