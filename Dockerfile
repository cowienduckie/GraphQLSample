﻿FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["GraphQLSample.csproj", "./"]
RUN dotnet restore "GraphQLSample.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "GraphQLSample.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "GraphQLSample.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "GraphQLSample.dll"]
