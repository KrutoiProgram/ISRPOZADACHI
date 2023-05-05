# Список рецептов

Реализуем вывод списков рецептов и ингридиентов. Используем WPF и Entity Framework Core. 

## 1. Восстановление БД

Выполните восстановление базы данных из скрипта. Проверьте правильность генерации таблиц с помощью диаграммы.

![](1.png)

## 2. Создание проекта

Создайте проект WPF (Майкрософт).

Установите пакеты Entity Framework, выполните построение модели с помощью команды `Scaffold-DbContext`.

## 3. Разметка основного окна

В коде основного окна задайте в качестве компоновочного элемента `DockPanel`:
```xml
<DockPanel>
    <Border DockPanel.Dock="Top" Background="#D64045">
        <StackPanel
                HorizontalAlignment="Right"
                 Orientation="Horizontal">
            <Button Background="#E9FFF9"
                    Click="goToReceiptsPage"
                    Content="Список рецептов" Margin="6" Padding="10" Width="170" />
            <Button Background="#E9FFF9" Content="Список ингридиентов" Margin="6" Padding="10" Width="170"  />
        </StackPanel>
    </Border>
    <Frame x:Name="mainFrame" NavigationUIVisibility="Hidden" />
</DockPanel>
```
Примерный вид:
![](2.png)

## 4. Добавление страницы с рецептами

Добавьте страницу с рецептами `ReceiptsPage`. Реализуйте переход на эту страницу по нажатию на "Список рецептов":
```cs
private void goToReceiptsPage(object sender, RoutedEventArgs e)
{
    var page = new ReceiptsPage();
    mainFrame.Navigate(page);
}
```

Разметка страницы:
```xml
<ScrollViewer>
    <ItemsControl x:Name="receiptsItemsControl">
        <ItemsControl.ItemTemplate>
            <DataTemplate>
                <Border >
                <Grid Margin="10">
                    <Grid.ColumnDefinitions>
                        <ColumnDefinition Width="200" />
                        <ColumnDefinition />
                    </Grid.ColumnDefinitions>
                    <StackPanel Grid.Column="1">
                        <TextBlock FontSize="20" Text="{Binding Name}" />
                        <TextBlock TextWrapping="WrapWithOverflow" Text="{Binding Description}" />
                        <TextBlock Text="Ингридиенты: " />
                    </StackPanel>
                </Grid>
                </Border>
            </DataTemplate>
        </ItemsControl.ItemTemplate>
    </ItemsControl>
</ScrollViewer>
```

В коде страницы выполните загрузку записей из базы данных:
```cs
public ReceiptsPage()
{
    InitializeComponent();
    using (var context = new ReceiptsWpfContext())
    {
        receiptsItemsControl.ItemsSource = context.Receipts.ToList();
    }
}
```

Проверьте работоспособность.

## 5. Вывод ингридиентов

Добавим в разметку элемента еще один `ItemsControl`:
```xml
<DataTemplate>
    <Border >
    <Grid Margin="10">
        <Grid.ColumnDefinitions>
            <ColumnDefinition Width="200" />
            <ColumnDefinition />
        </Grid.ColumnDefinitions>
        <StackPanel Grid.Column="1">
            <TextBlock FontSize="20" Text="{Binding Name}" FontWeight="Bold" />
            <TextBlock TextWrapping="WrapWithOverflow" Text="{Binding Description}" />
            <TextBlock Text="Ингридиенты: " FontSize="16" FontWeight="DemiBold" />
                <ItemsControl ItemsSource="{Binding ReceiptIngridients}">
                    <ItemsControl.ItemTemplate>
                        <DataTemplate>
                            <TextBlock>
                                <Run Text="{Binding IngridientNavigation.Name}" />
                                <Run Text=" - " />
                                <Run Text="{Binding Count}" />
                            </TextBlock>
                        </DataTemplate>
                    </ItemsControl.ItemTemplate>
                </ItemsControl>
            </StackPanel>
    </Grid>
    </Border>
</DataTemplate>
```

Выполним загрузку связанных сущностей с помощью `Include` (изменим конструктор):
```cs
using (var context = new ReceiptsWpfContext())
{
    receiptsItemsControl.ItemsSource = context
        .Receipts
        .Include(r => r.ReceiptIngridients)
        .ThenInclude(ri => ri.IngridientNavigation)
        .ToList();
}
```

Провеньте работоспособность.
При необходимости исправьте код разметки.

## 6. Добавление изображений

Добавьте в папку с проектом изображения:
![](3.png)

Укажите для них "копировать в выходной каталог":
![](4.png)

Добавим `Image` (в `DataTemplate` элемента):
```xml
<Image Grid.Column="0" Source="{Binding Image}" />
```

При запуске картинки не загрузятся. Нам необходимо конвертировать пути. Напишем конвертер. 
Сперва создадим класс:
![](5.png)

Реализуем интерфейс `IValueConverter`:
```cs
internal class ImagePathConverter : IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, CultureInfo culture)
    {
        if (value == null)
        {
            return string.Empty;
        }
        string filename = (string)value;
        return Path.Combine(Environment.CurrentDirectory, "Images", filename);
    }

    public object ConvertBack(object value, Type targetType, object parameter, CultureInfo culture)
    {
        throw new NotImplementedException();
    }
}
```

Добавим конвертер в ресурсы страницы (страница с рецептами). Сперва подключим namespace:
```xml
xmlns:conv="clr-namespace:WpfDemo1703.Converters"
```

Затем добавим строки:
```xml
<Page.Resources>
    <conv:ImagePathConverter x:Key="imageConverter" />
</Page.Resources>
```

После этого изменим привязку:
```xml
<Image Grid.Column="0" 
   Margin="10"
   Source="{Binding Image, Converter={StaticResource imageConverter}}" />
```

Проверьте работоспособность. Примерный результат:
![](6.png)

## 7. Самостоятельная работа

### 7.1 Поиск по названию

Реализуйте поиск рецепта по его названию.

### 7.2 Окно с ингридиентами

Выведите список всех ингридиентов на отдельной странице (в ListView или DataGrid). Необходимо вывести следующее:
- идентификатор ингридиента;
- название ингридента;
- список рецептов, в которых этот ингридиент встречается.

Добавьте возможность поиска по названию ингридиента.

## Дополнительно

Реализуйте поиск рецепта по названию ингридиента. В результате такого поиска находятся все рецепты, в которых присутстует написанный ингридиент.