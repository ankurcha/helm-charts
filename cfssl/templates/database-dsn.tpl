{{- define "database_dsn" -}}
{
    "driver": "postgres",
    "data_source": "postgres://__POSTGRES_DATABASE_USER__:__POSTGRES_DATABASE_PASSWORD__@database/cfssl?sslmode=disable"
}
{{- end -}}
