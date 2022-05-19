from django.shortcuts import render


def index(request):
    return render(request, "index.html")


def trigger_error(request):
    a = 1
    b = 0
    a / b
