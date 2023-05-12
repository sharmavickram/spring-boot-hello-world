FROM openjdk:8
EXPOSE 8080
ADD target/HelloWorld-0.0.1-SNAPSHOT.jar HelloWorld-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java","-jar","/HelloWorld-0.0.1-SNAPSHOT.jar"]