FROM debian:bookworm-slim

# Instala as ferramentas essenciais
RUN sudo apt-get update && sudo apt-get install -y \
    wget curl git unzip xz-utils zip libglu1-mesa \
    libwebkit2gtk-4.0-dev clang cmake ninja-build \
    pkg-config libgtk-3-dev liblzma-dev \
    libstdc++-12-dev build-essential libglib2.0-dev \
    libcairo2-dev libpango1.0-dev libjpeg-dev libpng-dev \
    libharfbuzz-dev libicu-dev libzip-dev libnss3-dev \
    fonts-liberation libfreetype6-dev libasound2-dev \
    libx11-dev libxext-dev libxrender-dev libxss-dev \
    libglu1-mesa-dev libffi-dev libdbus-1-dev \
    libpulse-dev zlib1g-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad

# Adiciona o repositório do Flutter
RUN echo "deb https://storage.googleapis.com/flutter_infra/flutter.io/debian bookworm main" >> /etc/apt/sources.list.d/flutter.list

# Adiciona a chave do repositório
RUN curl https://storage.googleapis.com/flutter_infra/flutter.io/debian/public.key | apt-key add -

# Atualiza e instala o Flutter
RUN apt-get update && apt-get install -y flutter

# Configura o Flutter
ENV PATH="/usr/local/bin:$PATH"

# Adiciona o usuário 'flutter'
RUN useradd -ms /bin/bash flutter

# Define o usuário 'flutter' como o usuário padrão
USER flutter

# Define o diretório de trabalho
WORKDIR /home/flutter/project

# Define a porta para o servidor de desenvolvimento do Flutter
EXPOSE 5555