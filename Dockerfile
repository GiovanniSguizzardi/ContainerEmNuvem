# Escolher a imagem base
FROM openjdk:17-jdk-slim

# Configura o diretório de trabalho
WORKDIR /app

# Copia o arquivo JAR da aplicação para o contêiner
COPY target/brinquedos_repositorio.jar /app/app.jar

# Expõe a porta que a aplicação vai rodar
EXPOSE 8080

# Comando para iniciar a aplicação
ENTRYPOINT ["java", "-jar", "/app/app.jar"]