# Текстовый редактор

Разработаем простой текстовый редактор. Выполним компоновку элементов с помощью `DockPanel`. Используем меню, контекстное меню, панель инструментов и строку состояния. Для обработки пользовательских сообщений (событий) используем команды.


## 1. Команды

Помимо обработчиков событий, в WPF (и других технологиях, использующих язык XAML), мы можем использовать команды. Более подробно, вы можете изучить по ссылкам:
https://learn.microsoft.com/ru-ru/dotnet/desktop/wpf/advanced/commanding-overview?view=netframeworkdesktop-4.8
https://metanit.com/sharp/wpf/7.1.php

В целом, мы можем пойти одним из способов:
- реализовать интерфейс `ICommand` и использовать полученный класс;
- использовать стандартные команды `RouteUICommand`.

В данной работе мы пойдем по второму пути. Стандартные команды вы можете найти в статических классах, вроде `ApplicationCommands`, `EditingCommands` или `MediaCommands`. Часть из этих команд **уже имеет реализацию**, часть - **требует написания обработчиков событий**.

![](1.png)

## 2. Создание пользовательского интерфейса

Основным компоновочным элементом зададим `DockPanel`.

Внутри расположим меню:
```xml
<DockPanel>
    <Menu DockPanel.Dock="Top">
        <MenuItem Header="Файл">
            <MenuItem Header="Открыть" />
            <MenuItem Header="Сохранить" />
            <Separator />
            <MenuItem Header="Выход" />
        </MenuItem>
        <MenuItem Header="Правка">
            <MenuItem Header="Вырезать" />
            <MenuItem Header="Копировать" />
            <MenuItem Header="Вставить" />
            <Separator />
            <MenuItem Header="Выделить все" />
        </MenuItem>
        <MenuItem Header="Формат">
            <MenuItem Header="Шрифт" />
        </MenuItem>
        <!-- Добавьте самостоятельно меню "Справка" с пунктом "О программе" -->
    </Menu>
</DockPanel>
```

Внутри элемента `Menu` размещаются `MenuItem`. Каждый из `MenuItem` может включать в себя новые `MenuItem`, что позволяет создать в меню определенную иерархию.

Меню "приклеиваем" к верхней части `DockPanel` с помощью `DockPanel.Dock="Top"`.

Далее, добавим панель инструментов:
```xml
<ToolBar DockPanel.Dock="Top">
            
</ToolBar>
```

Строку состояния:
```xml
<StatusBar DockPanel.Dock="Bottom">

</StatusBar>
```

И последний элемент (поле ввода), который займет все оставшееся пространство (мы не указываем `DockPanel.Dock`):
```xml
<RichTextBox />
```

Добавим в `ToolBar` кнопки. Сперва импортируем иконки (см. папку с заданием). 
![](2.png)

Далее, добавим кнопки (внимание! У вас могут отличаться пути и имена файлов):
```xml
<ToolBar DockPanel.Dock="Top">
    <Button>
        <Image Width="20" ToolTip="Открыть" Source="./Images/Icons/56x56/icons8-opened-folder-52.png" />
    </Button>
    <Button>
        <Image Width="20" ToolTip="Сохранить" Source="./Images/Icons/56x56/icons8-save-52.png" />
    </Button>
    <Separator />
    <Button>
        <Image Width="20" ToolTip="Вырезать" Source="./Images/Icons/56x56/icons8-cut-52.png" />
    </Button>            
    <Button>
        <Image Width="20" ToolTip="Копировать" Source="./Images/Icons/56x56/icons8-copy-52.png" />
    </Button>
    <Button>
        <Image Width="20" ToolTip="Вставить" Source="./Images/Icons/56x56/icons8-paste-52.png" />
    </Button>
    <Separator />
    <Button>
        <Image Width="20" Source="./Images/Icons/56x56/icons8-exit-sign-52.png" />
    </Button>
</ToolBar>
```

Если у вас не загружаются картинки, проверьте, что они установлены как ресурсы:
![](3.png)

В коде выше, свойство `ToolTip` позволяет выводить всплывающую подсказку:
![](4.png)

В строке состояния пока что оставим текст-заглушку:
```xml
<StatusBar DockPanel.Dock="Bottom">
    <Label Content="Все хорошо" />
</StatusBar>
```

Далее, добавим контекстное меню. Сперва опишем его в ресурсах `Window`:
```xml
<Window.Resources>
    <ContextMenu x:Key="contentContextMenu">
        <MenuItem Header="Вырезать" />
        <MenuItem Header="Копировать" />
        <MenuItem Header="Вставить" />
        <MenuItem Header="Выделить все" />
    </ContextMenu>
</Window.Resources>
```

Затем назначим его `RichTextBox`:
```xml
<RichTextBox Foreground="Black" ContextMenu="{StaticResource contentContextMenu}" />
```

Проверьте работоспособность (контекстное меню вызывается на ПКМ).

**Самостоятельно** добавьте пунктам меню иконки. Используйте свойство `Icon`:
https://learn.microsoft.com/ru-ru/dotnet/api/system.windows.controls.menuitem.icon?view=windowsdesktop-7.0

## 3. Добавление команд

### 3.1 Команды со стандартной реализацией

Добавим команды. Логика команд для редактирования текста (копировать, вырезать, вставить, выделить все) определена по умолчанию. Поэтому мы просто можем назначить существующие команды. В контекстном меню:
```xml
...
    <MenuItem Header="Вырезать" Command="Cut" />
    <MenuItem Header="Копировать" Command="Copy" />
    <MenuItem Header="Вставить" Command="Paste" />
    <MenuItem Header="Выделить все" Command="SelectAll" />
...
```

В основном меню:
```xml
...
    <MenuItem Header="Правка">
        <MenuItem Header="Вырезать" Command="Cut" />
        <MenuItem Header="Копировать" Command="Copy" />
        <MenuItem Header="Вставить" Command="Paste" />
        <Separator />
        <MenuItem Header="Выделить все" Command="SelectAll" />
    </MenuItem>
...
```

В панели элементов:
```xml
...
<Button Command="Cut">
    <Image Width="20" ToolTip="Вырезать" Source="./Images/Icons/56x56/icons8-cut-52.png" />
</Button>
...
```

Проверьте работоспособность. Обратите внимание, что:
- команды могут быть доступны или недоступны для выполнения, в зависимости от выбранного текста;
- для команд сразу определены горячие клавиши;


### 3.2 Команды без стандартной реализации

Добавим команду выхода:
```xml
...
<MenuItem Header="Выход" Command="Close" />
...
```

```xml
...
<Button ToolTip="Выход" Command="Close">
...
```

Проверьте работоспособность. После добавления команды, кнопка выхода будет недоступна.

Свяжем с командой обработчик событий. Для этого используем свойство окна `CommandBindings`:
```xml
<Window.CommandBindings>
    <CommandBinding Command="Close" Executed="closeWindow" />
</Window.CommandBindings>
```

Метод `closeWindow` создаем также, как и обычный обрабочик событий. Код метода:
```cs
private void closeWindow(object sender, ExecutedRoutedEventArgs e)
{
    Close();
}
```

Проверьте работоспособность.

Свяжем команду с сочетанием клавиш Alt+Q. Используем `InputBindings`:
```xml
<Window.InputBindings>
    <KeyBinding Command="Close" Key="Q" Modifiers="Alt" />
</Window.InputBindings>
```
Добавим подсказку на сам элемент меню:
```xml
...
<MenuItem Header="Выход" Command="Close" InputGestureText="Alt-Q" />
...
```

Проверьте работоспособность.

Теперь реализуем сохранение файла. Добавим команду `Save` на пункт меню и на кнопку в панели инструментов:
```xml
<Button ToolTip="Сохранить" Command="Save">
```
```xml
<MenuItem Header="Сохранить" Command="Save" />
```

Выполним привязку к обработчику события:
```xml
<CommandBinding Command="Save" Executed="saveContent" />
```

```cs
private void saveContent(object sender, ExecutedRoutedEventArgs e)
{
    // тут будет код
}
```

В коде обработчика сперва добавим вызов диалогового окна для получения имени файла:
```cs
private void save(string filename)
{

}

private void saveContent(object sender, ExecutedRoutedEventArgs e)
{
    SaveFileDialog dialog = new SaveFileDialog
    {
        Filter = "Rich text format|*.rtf",
        DefaultExt = "rtf"
    };
    var result = dialog.ShowDialog();
    if (result == true)
    {
        save(dialog.FileName);
    }
}
```

Для сохранения используем свойство `RichTextBox` `Document`. Получим указатели на начало и конец содержимого `TextPointer`. Затем получим само содержимое.

Код метода `save`:
```cs
private void save(string filename)
{
    // contentTextBox - x:Name для RichTextBox
    // получаем указатели начала и конца
    // всего текста
    TextPointer start = contentTextBox.Document.ContentStart;
    TextPointer end = contentTextBox.Document.ContentEnd;

    // получаем по указателям TextPointer содержимое
    TextRange content = new TextRange(start, end);

    // выполняем сохранение с помощью специального метода Save
    using (var file = new FileStream(filename, FileMode.Create))
    {
        content.Save(file, DataFormats.Rtf);
    }
}
```

Проверьте работоспособность.

**Самостоятельно** добавьте для сохранения горячую клавишу Ctrl-S.
**Самостоятельно** реализуйте открытие файла.

Дополнительная информация:
https://learn.microsoft.com/ru-ru/dotnet/desktop/wpf/controls/richtextbox-overview?view=netframeworkdesktop-4.8

### 3.3 Добавление своих команд

Создадим команду для пункта меню "Шрифт".

Сперва **самостоятельно** добавьте новое окно `FontDialog`. Создайте для него интерфейс примерно следующего вида:
![](5.png)

Для работы также создадим два класса. Первый класс для удобства передачи информации о шрифте:
```cs
public class FontInfo
{
    public Brush Color { get; set; } 
    public FontFamily FontFamily { get; set; }
    public double FontSize { get; set; }
    public bool IsItallic { get; set; }
    public bool IsBold { get; set; }
}
```

Второй класс для привязки данных:
```cs
public class FontDialogViewModel
    {
        public FontInfo FontInfo { get; }
        public List<FontFamily> FontFamilies { get; }
        public List<double> Sizes { get; }
        public List<Brush> Colors { get; }

        public FontDialogViewModel(FontInfo fontInfo)
        {
            FontInfo = fontInfo;
            Sizes = new List<double>
            {
                10, 12, 14, 16, 18, 20, 22, 24, 26, 32, 42, 72
            };

            Colors = typeof(Brushes).GetProperties().Select(prop => (Brush)prop.GetValue(null)).ToList();

            FontFamilies = Fonts.SystemFontFamilies.ToList();
        }
    }
```

Изменим код конструктора, чтобы окно принимало параметром информацию о шрифте. Также, сразу зададим контекст для привязки:
```cs
public FontDialog(FontInfo info)
{
    InitializeComponent();
    DataContext = new FontDialogViewModel(info);
}
```

Вернемся к основному окну. Создадим команду. Есть два способа:
- создать экземпляр `RoutedUICommand` через код;
- создать экземпляр `RoutedUICommand` с помощью ресурсов;

Создадим через ресурсы. Для этого добавим в ресурсы (`Window.Resouces`) окна строчку:
```xml
<RoutedUICommand x:Key="fontDialogCommand" Text="Шрифт" />
```

Далее, добавим привязку обработчика:
```xml
<CommandBinding Command="{StaticResource fontDialogCommand}" Executed="goToFontDialog" />
```

Сам метод `goToFontDialog` будет включать в себя получение свойств для шрифта и вызов диалового окна:
```cs
private void goToFontDialog(object sender, ExecutedRoutedEventArgs e)
{
    TextRange content = contentTextBox.Selection;
    FontInfo fontInfo = new FontInfo
    {
        Color = (Brush)content.GetPropertyValue(ForegroundProperty) ,
        FontFamily = (FontFamily)content.GetPropertyValue(FontFamilyProperty),
        FontSize = (double)content.GetPropertyValue(FontSizeProperty),
        IsBold = (FontWeight)content.GetPropertyValue(FontWeightProperty) == FontWeights.Bold,
        IsItallic = (FontStyle)content.GetPropertyValue(FontStyleProperty) == FontStyles.Italic
    };

    FontDialog dialog = new FontDialog(fontInfo);
    var result = dialog.ShowDialog();
    if (result == true)
    {
        // назначим новый шрифт
    }
}
```

Загрузку `FontInfo` можно вынести в отдельный метод:
```cs
private FontInfo loadFontInfo()
{
    TextRange content = contentTextBox.Selection;
    return new FontInfo
    {
        Color = (Brush)content.GetPropertyValue(ForegroundProperty),
        FontFamily = (FontFamily)content.GetPropertyValue(FontFamilyProperty),
        FontSize = (double)content.GetPropertyValue(FontSizeProperty),
        IsBold = (FontWeight)content.GetPropertyValue(FontWeightProperty) == FontWeights.Bold,
        IsItallic = (FontStyle)content.GetPropertyValue(FontStyleProperty) == FontStyles.Italic
    };
}

private void useFontInfo(FontInfo fontInfo)
{
    // ...
}

private void goToFontDialog(object sender, ExecutedRoutedEventArgs e)
{

    var font = loadFontInfo();
    FontDialog dialog = new FontDialog(font);
    var result = dialog.ShowDialog();
    if (result == true)
    {
        // useFontInfo() с параметром FontInfo, полученным из диалогового окна
    }
}
```

В диалоговом окне выполним привязку данных
Размер шрифта:
```xml
<Label>Размер</Label>
<ComboBox ItemsSource="{Binding Sizes}" SelectedItem="{Binding FontInfo.FontSize}" />
```

Цвет:
```xml
<Label>Цвет</Label>
<ComboBox HorizontalContentAlignment="Stretch" 
          SelectedItem="{Binding FontInfo.Color}" 
          ItemsSource="{Binding Colors}">
    <ComboBox.ItemTemplate>
        <DataTemplate>
            <Border Height="16" Background="{Binding }" />
        </DataTemplate>
    </ComboBox.ItemTemplate>
</ComboBox>
```

Для курсивного и полужирного шрифтов:
```xml
<CheckBox Content="Курсив" FontStyle="Italic" IsChecked="{Binding FontInfo.IsItallic}" />
<CheckBox Content="Полужирный" IsChecked="{Binding FontInfo.IsBold}" />
```

Для вывода списка шрифтов реализуйте привязку **самостоятельно**.
![](6.png)

Добавим в код диалогового окна свойство:
```cs
public FontInfo? FontInfo => (DataContext as FontDialogViewModel)?.FontInfo;
```

За счет того, что `FontInfo` привязано к элементам управления, в его полях будут выбранные пользователем значения.
Напишем обработчик нажатия на кнопку `Cancel`:
```cs
private void cancel(object sender, RoutedEventArgs e)
{
    DialogResult = false;
    Close();
}
```
Самой кнопке установим свойство `IsCancel` в true, чтобы кнопка работала на нажатие ESC.

Напишем обработчик нажатия на кнопку "принять":
```cs
private void accept(object sender, RoutedEventArgs e)
{
    DialogResult = true;
    Close();
}
```

Самой кнопке установим свойство `IsDefault` в true, чтобы кнопка работала по нажатию Enter.


В главном окне реализуем изменение шрифта:
```cs
private FontInfo loadFontInfo()
{
    TextRange content = contentTextBox.Selection;
    return new FontInfo
    {
        Color = (Brush)content.GetPropertyValue(ForegroundProperty),
        FontFamily = (FontFamily)content.GetPropertyValue(FontFamilyProperty),
        FontSize = (double)content.GetPropertyValue(FontSizeProperty),
        IsBold = (FontWeight)content.GetPropertyValue(FontWeightProperty) == FontWeights.Bold,
        IsItallic = (FontStyle)content.GetPropertyValue(FontStyleProperty) == FontStyles.Italic
    };
}

private void useFontInfo(FontInfo fontInfo)
{
    TextRange content = contentTextBox.Selection;
    content.ApplyPropertyValue(ForegroundProperty, fontInfo.Color);
    content.ApplyPropertyValue(FontFamilyProperty, fontInfo.FontFamily);
    content.ApplyPropertyValue(FontSizeProperty, fontInfo.FontSize);
    content.ApplyPropertyValue(FontWeightProperty, fontInfo.IsBold ? FontWeights.Bold : FontWeights.Normal);
    content.ApplyPropertyValue(FontStyleProperty, fontInfo.IsItallic ? FontStyles.Italic : FontStyles.Normal);
}

private void goToFontDialog(object sender, ExecutedRoutedEventArgs e)
{

    var font = loadFontInfo();
    FontDialog dialog = new FontDialog(font);
    var result = dialog.ShowDialog();
    if (result == true)
    {
        useFontInfo(dialog.FontInfo);
    }
}
```

Проверьте работоспособность. Редактор должен изменять шрифт выделенного фрагмента.



## Дополнительно

### Строка состояния

Реализуйте вывод следующей информации в строке состояния:
- количество символов;
- текущая позиция курсора;
- состояние клавиши Caps Lock.

### Печать файла

Реализуйте возможность печати документа. Добавьте соответствующий пункт меню и кнопку на панели инструментов. Используйте команду (стандартная команда Print). Установите горячую клавишу CTRL-P.

### Сохранение

При старте программы или при открытии файла, будем считать документ *не измененным*. Как только содержимое документа изменилось, он становится уже *измененным*. 

Добавьте два пункта в меню "Файл": "Новый" и "Сохранить как".

"Новый" очищает текст и ставит состояние файла в "не изменен". 
"Сохранить как" выполняет запись по указанному в диалоговом окне пользователем пути (прежняя реализация "сохранить").
"Открыть" выполняет открытие файла и сохраняет его имя. Имя файла должно быть показано в заголовке окна. После открытия файла, кнопка "сохранить" выполняет его перезапись. Каждая успешная перезапись сбрасывает состояние в "не изменен".
При попытке закрытия окна или создания нового файла, если состояние было "изменен", появляется диалоговое окно с подтверждением, предупреждающее, что несохраненные изменения будут потеряны.