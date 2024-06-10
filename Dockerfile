FROM python:3.6
COPY ./src/ /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 2000
ENTRYPOINT ["python"]
CMD ["app.py"]
