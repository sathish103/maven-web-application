FROM maven AS build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM tomcat
COPY --from=build /app/target/jav-webapp.war /usr/local/tomcat/webapps 