# Use the official .NET SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

# Set the working directory
WORKDIR /app

# Copy the project file and restore dependencies from BlazorChatApp/BlazorChatApp
COPY ["BlazorChatApp/BlazorChatApp/BlazorChatApp.csproj", "BlazorChatApp/BlazorChatApp/"]
RUN dotnet restore "BlazorChatApp/BlazorChatApp/BlazorChatApp.csproj"

# Copy the rest of the application code
COPY . .

# Publish the application
WORKDIR "/app/BlazorChatApp/BlazorChatApp"
RUN dotnet publish "BlazorChatApp.csproj" -c Release -o /app/publish

# Use the official .NET runtime image to run the app
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Copy the published application from the build stage
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "BlazorChatApp.dll"]
