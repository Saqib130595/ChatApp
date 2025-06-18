# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project files and restore dependencies
COPY ["BlazorChatApp/BlazorChatApp.csproj", "BlazorChatApp/"]
RUN dotnet restore "BlazorChatApp/BlazorChatApp.csproj"

# Publish the application
COPY . .
WORKDIR "/app/BlazorChatApp"
RUN dotnet publish "BlazorChatApp.csproj" -c Release -o /app/publish

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "BlazorChatApp.Server.dll"]
