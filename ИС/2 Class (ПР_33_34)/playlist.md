# Плейлист

Реализуем класс "плейлист".

## Track

Начнем с описания структуры для композиции:
```cs
    struct Song
    {
        public string Author;
        public string Title;
        public string Filename;
    }
```
Здесь, `Author` - автор, `Title` - название, `Filename` - путь до файла с мелодией.

## Playlist

Далее, мы создадим класс `Playlist`, добавим в него конструктор, поля для списка композиций и индеса текущей песни:
```cs
    class Playlist
    {
        private List<Song> list;
        private int currentIndex;

        public Playlist()
        {
            list = new List<Song>();
            currentIndex = 0;
        }
    }
```

+Метод для получения текущей аудиозаписи:
```cs
        public Song CurrentSong()
        {
            if (list.Count > 0)
                return list[currentIndex];
            else
                throw new IndexOutOfRangeException("Невозможно получить текущую аудиозапись для пустого плейлиста!");
        }
```

Полученный результат:
```cs
    class Playlist
    {
        private List<Song> list;
        private int currentIndex;

        public Playlist()
        {
            list = new List<Song>();
            currentIndex = 0;
        }
        
        public Song CurrentSong()
        {
            if (list.Count > 0)
                return list[currentIndex];
            else
                throw new IndexOutOfRangeException(
					"Невозможно получить текущую аудиозапись для пустого плейлиста!");
        }

    }
```

## Задача

Самостоятельно реализуйте и проверьте методы для:
* добавления аудиозаписи (попробуйте сделать 2 перегрузки!);
* переход к следующей (помните про выход за границы массива!);
* переход к предыдущей;
* переход по индексу записи;
* переход к началу списка;
* удаление композиции (попробуйте сделать 2 перегрузки для удаления: по индексу, по значению типа `Song` при первом совпадении);
* очистки плейлиста
