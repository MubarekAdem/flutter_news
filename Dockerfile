FROM instrumentisto/flutter
RUN flutter channel stable \
  && flutter upgrade \
  && flutter config --enable-web
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web
EXPOSE 5000
CMD ["flutter", "run", "-d", "web-server", "--web-port", "8080", "--web-hostname", "0.0.0.0"]
