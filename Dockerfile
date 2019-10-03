FROM microsoft/dotnet:2.2-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /src
COPY ["DockerPOC/DockerPOC.csproj", "DockerPOC/"]
RUN dotnet restore "DockerPOC/DockerPOC.csproj"
COPY . .
WORKDIR "/src/DockerPOC"
RUN dotnet build "DockerPOC.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerPOC.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerPOC.dll"]