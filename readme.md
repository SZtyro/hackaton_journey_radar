### Zbuduj angulara
Bez niego serwer może nie ruszyć bo nie ma co wystawić 
```ng b```
### Utwórz bazę w pgAdmin
Upewnij się, że ma takie same dane jak w .env
### Dodaj .env do głownego folderu
Bez niego serwer nie połączy z bazą
```
DATABASE_URL=postgresql://localhost:5432/hackaton_template
DATABASE_USER=local
DATABASE_PASSWORD=local
```