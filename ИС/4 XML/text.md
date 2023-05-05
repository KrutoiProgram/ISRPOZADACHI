# 1 Обработка XML


За основу возьмем файл:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<students>
	<student id="1">
		<surname>Иванов</surname>
		<name>Иван</name>
		<phone>84445553322</phone>
	</student>
	<student id="2">
		<surname>Петров</surname>
		<name>Петр</name>
		<phone>85554323322</phone>
	</student>
	<student id="3">
		<surname>Иванова</surname>
		<name>Ксения</name>
		<phone>81234443322</phone>
	</student>
	<student id="4">
		<surname>Петрова</surname>
		<name>Алена</name>
		<phone>86664443322</phone>
	</student>
	<student id="5">
		<surname>Гаражный</surname>
		<name>Серафим</name>
		<phone>85554443366</phone>
	</student>
</students>
```
Корневым элементом является `<students>`. Внутри корневого элемента имеется массив из `<student>`. Каждый студент имеет аттрибут `id`, и несколько свойств (внутренних тегов/узлов): `<name>`, `<surname>`, `<phone>`.

Задача: 
научиться обрабатывать XML на примере данного документа.

## 1.1 Добавление документа в проект

Для простоты создадим **консольное приложение**. Добавим в него файл:
![](1.png "add element" "width:600px")
![](2.png "add element" "width:600px")

В свойствах файла зададим копирование в выходной каталог:
![](3.png "copy newer version" "width:400px")

После чего в файл можно скопировать содержимое из начала данного документа (XML со студентами).

## 1.2 Работа с System.Xml

Используем сборку `System.Xml`. Ниже приведены примеры использования классов из данного пространства имен.

Открытие файла:
```cs
using System.Xml;

// создаем экземпляр XmlDocument
XmlDocument doc = new XmlDocument();
// загружаем "students.xml"
doc.Load("students.xml");

// выводим информацию об узле (#document)
Console.WriteLine("Текущий узел: ");
Console.WriteLine(doc.Name);
Console.WriteLine();
Console.WriteLine("XML: ");
Console.WriteLine(doc.OuterXml);
```

Получение корневого элемента с помощью свойства `DocumentElement`:
```cs
var root = doc.DocumentElement;
```

```cs
using System.Xml;

XmlDocument doc = new XmlDocument();
doc.Load("students.xml");

var root = doc.DocumentElement;

Console.WriteLine($"Корневой элемент: {root.Name}");
Console.WriteLine("Текст:");
Console.WriteLine(root.OuterXml);
```

Получение первого дочернего элемента:
```cs
using System.Xml;

XmlDocument doc = new XmlDocument();
doc.Load("students.xml");

var root = doc.DocumentElement;

var first = root.ChildNodes[0]; // или можно использовать root.FirstChild

Console.WriteLine("Первый узел");
Console.WriteLine($"Имя: {first.Name}");
Console.WriteLine($"Количество дочерних элементов: {first.ChildNodes.Count}");
Console.WriteLine($"Id: {first.Attributes["id"].Value}");
```

Получение всех значений для первого узла:
```cs
using System.Xml;

XmlDocument doc = new XmlDocument();
doc.Load("students.xml");

var root = doc.DocumentElement;

var first = root.ChildNodes[0]; // или можно использовать root.FirstChild

Console.WriteLine($"Id: {first.Attributes["id"].Value}");

// перебор всех дочерних узлов
foreach (XmlNode child in first.ChildNodes)
{
    Console.WriteLine($"{child.Name} : {child.InnerText}");
}
```

Перебор всех студентов:
```cs
using System.Xml;

XmlDocument doc = new XmlDocument();
doc.Load("students.xml");

var students = doc.DocumentElement;

foreach (XmlNode student in students)
{
    Console.WriteLine($"Id: {student.Attributes["id"].InnerText}");
    foreach (XmlNode property in student)
    {
        Console.WriteLine($"{property.Name} : {property.InnerText}");
    }
}
```

В случае, если уровней вложенности очень много, и необходимо обойти все узлы дерева, может быть полезным использование рекурсии:
```cs
using System.Xml;

XmlDocument doc = new XmlDocument();
doc.Load("students.xml");

var students = doc.DocumentElement;

WriteNode(students);

/// обход всех узлов в и вывод их имен
void WriteNode(XmlNode node)
{
    // пограничный случай: узел не имеет потомков (текст)
    if (!node.HasChildNodes)
    {
        return;
    }

    Console.WriteLine(node.Name);

    foreach (XmlNode child in node.ChildNodes)
    {
        WriteNode(child);
    }
}
```

## 1.3 Использование Linq to XML

Также, можно использовать сборку `System.Xml.Linq`. Примеры использования представлены ниже.

Получение коллекции узлов:
```cs
using System.Xml.Linq;

// открываем файл
XDocument doc = XDocument.Load("students.xml");

// получаем все узлы в виде коллекции XElement
// используем методы Element и Elements
var students = doc.Element("students")
    .Elements("student");

// вывод
foreach (var student in students)
{
    Console.WriteLine(student);
}
```

Получение списка имен:
```cs
using System.Xml.Linq;

// открываем файл
XDocument doc = XDocument.Load("students.xml");

// получаем все узлы в виде коллекции XElement
var students = doc.Element("students")
    .Elements("student");
// получаем с помощью Linq имена
var names = students
    .Select(st => st.Element("name").Value);

foreach (var name in names)
{
    Console.WriteLine(name);
}
```
Или сразу:
```cs
using System.Xml.Linq;

XDocument doc = XDocument.Load("students.xml");

var names = doc.Element("students")
    .Elements("student")
    .Select(student => student.Element("name").Value);

foreach (var name in names)
{
    Console.WriteLine(name);
}
```

В целом, используя методы `Linq` в сочетании с `XDocument`, `XElement` и методами `Element` и `Elements`, возможно без проблем решать различные задачи по обработке XML-документов.

## 1.4 Задача

Потренируйтесь в чтении и обработке XML-файлов (п. 1.2 и 1.3).

Обработайте файл `valutes.xml`, выполните любым из способов:
- вывод списка названий валют и их курса;
- определение самого высокого и самого низкого курса(`<value>`);
- реализацию поиска валюты по ее сокращенному названию;

Файл:
```xml
<ValCurs Date="14.01.2022" name="Foreign Currency Market">
	<Valute ID="R01010">
		<NumCode>036</NumCode>
		<CharCode>AUD</CharCode>
		<Nominal>1</Nominal>
		<Name>Австралийский доллар</Name>
		<Value>54,5022</Value>
	</Valute>
	<Valute ID="R01020A">
		<NumCode>944</NumCode>
		<CharCode>AZN</CharCode>
		<Nominal>1</Nominal>
		<Name>Азербайджанский манат</Name>
		<Value>43,8897</Value>
	</Valute>
	<Valute ID="R01035">
		<NumCode>826</NumCode>
		<CharCode>GBP</CharCode>
		<Nominal>1</Nominal>
		<Name>Фунт стерлингов Соединенного королевства</Name>
		<Value>102,4945</Value>
	</Valute>
	<Valute ID="R01060">
		<NumCode>051</NumCode>
		<CharCode>AMD</CharCode>
		<Nominal>100</Nominal>
		<Name>Армянских драмов</Name>
		<Value>15,4466</Value>
	</Valute>
	<Valute ID="R01090B">
		<NumCode>933</NumCode>
		<CharCode>BYN</CharCode>
		<Nominal>1</Nominal>
		<Name>Белорусский рубль</Name>
		<Value>29,0659</Value>
	</Valute>
	<Valute ID="R01100">
		<NumCode>975</NumCode>
		<CharCode>BGN</CharCode>
		<Nominal>1</Nominal>
		<Name>Болгарский лев</Name>
		<Value>43,7429</Value>
	</Valute>
	<Valute ID="R01115">
		<NumCode>986</NumCode>
		<CharCode>BRL</CharCode>
		<Nominal>1</Nominal>
		<Name>Бразильский реал</Name>
		<Value>13,4739</Value>
	</Valute>
	<Valute ID="R01135">
		<NumCode>348</NumCode>
		<CharCode>HUF</CharCode>
		<Nominal>100</Nominal>
		<Name>Венгерских форинтов</Name>
		<Value>24,1213</Value>
	</Valute>
	<Valute ID="R01200">
		<NumCode>344</NumCode>
		<CharCode>HKD</CharCode>
		<Nominal>10</Nominal>
		<Name>Гонконгских долларов</Name>
		<Value>95,7198</Value>
	</Valute>
	<Valute ID="R01215">
		<NumCode>208</NumCode>
		<CharCode>DKK</CharCode>
		<Nominal>1</Nominal>
		<Name>Датская крона</Name>
		<Value>11,4992</Value>
	</Valute>
	<Valute ID="R01235">
		<NumCode>840</NumCode>
		<CharCode>USD</CharCode>
		<Nominal>1</Nominal>
		<Name>Доллар США</Name>
		<Value>74,5686</Value>
	</Valute>
	<Valute ID="R01239">
		<NumCode>978</NumCode>
		<CharCode>EUR</CharCode>
		<Nominal>1</Nominal>
		<Name>Евро</Name>
		<Value>85,4556</Value>
	</Valute>
	<Valute ID="R01270">
		<NumCode>356</NumCode>
		<CharCode>INR</CharCode>
		<Nominal>10</Nominal>
		<Name>Индийских рупий</Name>
		<Value>10,0830</Value>
	</Valute>
	<Valute ID="R01335">
		<NumCode>398</NumCode>
		<CharCode>KZT</CharCode>
		<Nominal>100</Nominal>
		<Name>Казахстанских тенге</Name>
		<Value>17,1442</Value>
	</Valute>
	<Valute ID="R01350">
		<NumCode>124</NumCode>
		<CharCode>CAD</CharCode>
		<Nominal>1</Nominal>
		<Name>Канадский доллар</Name>
		<Value>59,7840</Value>
	</Valute>
	<Valute ID="R01370">
		<NumCode>417</NumCode>
		<CharCode>KGS</CharCode>
		<Nominal>100</Nominal>
		<Name>Киргизских сомов</Name>
		<Value>87,9191</Value>
	</Valute>
	<Valute ID="R01375">
		<NumCode>156</NumCode>
		<CharCode>CNY</CharCode>
		<Nominal>1</Nominal>
		<Name>Китайский юань</Name>
		<Value>11,7246</Value>
	</Valute>
	<Valute ID="R01500">
		<NumCode>498</NumCode>
		<CharCode>MDL</CharCode>
		<Nominal>10</Nominal>
		<Name>Молдавских леев</Name>
		<Value>41,4616</Value>
	</Valute>
	<Valute ID="R01535">
		<NumCode>578</NumCode>
		<CharCode>NOK</CharCode>
		<Nominal>10</Nominal>
		<Name>Норвежских крон</Name>
		<Value>86,3312</Value>
	</Valute>
	<Valute ID="R01565">
		<NumCode>985</NumCode>
		<CharCode>PLN</CharCode>
		<Nominal>1</Nominal>
		<Name>Польский злотый</Name>
		<Value>18,8906</Value>
	</Valute>
	<Valute ID="R01585F">
		<NumCode>946</NumCode>
		<CharCode>RON</CharCode>
		<Nominal>1</Nominal>
		<Name>Румынский лей</Name>
		<Value>17,3057</Value>
	</Valute>
	<Valute ID="R01589">
		<NumCode>960</NumCode>
		<CharCode>XDR</CharCode>
		<Nominal>1</Nominal>
		<Name>СДР (специальные права заимствования)</Name>
		<Value>104,5347</Value>
	</Valute>
	<Valute ID="R01625">
		<NumCode>702</NumCode>
		<CharCode>SGD</CharCode>
		<Nominal>1</Nominal>
		<Name>Сингапурский доллар</Name>
		<Value>55,4496</Value>
	</Valute>
	<Valute ID="R01670">
		<NumCode>972</NumCode>
		<CharCode>TJS</CharCode>
		<Nominal>10</Nominal>
		<Name>Таджикских сомони</Name>
		<Value>66,0776</Value>
	</Valute>
	<Valute ID="R01700J">
		<NumCode>949</NumCode>
		<CharCode>TRY</CharCode>
		<Nominal>10</Nominal>
		<Name>Турецких лир</Name>
		<Value>55,0740</Value>
	</Valute>
	<Valute ID="R01710A">
		<NumCode>934</NumCode>
		<CharCode>TMT</CharCode>
		<Nominal>1</Nominal>
		<Name>Новый туркменский манат</Name>
		<Value>21,3358</Value>
	</Valute>
	<Valute ID="R01717">
		<NumCode>860</NumCode>
		<CharCode>UZS</CharCode>
		<Nominal>10000</Nominal>
		<Name>Узбекских сумов</Name>
		<Value>68,9298</Value>
	</Valute>
	<Valute ID="R01720">
		<NumCode>980</NumCode>
		<CharCode>UAH</CharCode>
		<Nominal>10</Nominal>
		<Name>Украинских гривен</Name>
		<Value>26,8722</Value>
	</Valute>
	<Valute ID="R01760">
		<NumCode>203</NumCode>
		<CharCode>CZK</CharCode>
		<Nominal>10</Nominal>
		<Name>Чешских крон</Name>
		<Value>35,2029</Value>
	</Valute>
	<Valute ID="R01770">
		<NumCode>752</NumCode>
		<CharCode>SEK</CharCode>
		<Nominal>10</Nominal>
		<Name>Шведских крон</Name>
		<Value>83,6740</Value>
	</Valute>
	<Valute ID="R01775">
		<NumCode>756</NumCode>
		<CharCode>CHF</CharCode>
		<Nominal>1</Nominal>
		<Name>Швейцарский франк</Name>
		<Value>81,7190</Value>
	</Valute>
	<Valute ID="R01810">
		<NumCode>710</NumCode>
		<CharCode>ZAR</CharCode>
		<Nominal>10</Nominal>
		<Name>Южноафриканских рэндов</Name>
		<Value>48,8097</Value>
	</Valute>
	<Valute ID="R01815">
		<NumCode>410</NumCode>
		<CharCode>KRW</CharCode>
		<Nominal>1000</Nominal>
		<Name>Вон Республики Корея</Name>
		<Value>62,9409</Value>
	</Valute>
	<Valute ID="R01820">
		<NumCode>392</NumCode>
		<CharCode>JPY</CharCode>
		<Nominal>100</Nominal>
		<Name>Японских иен</Name>
		<Value>65,1624</Value>
	</Valute>
</ValCurs>
```

Пример работы поиска:
```
Введите валюту для поиска:
TMT
Новый туркменский манат
Текущий курс: 21,3358
```

**Опционально:**
создать класс `Valute`, и использовать для работы список `List<Valute>`, предварительно загрузив в него все необходимые данные.


# 2. Конвертор валют

Разработаем конвертер валют. Для преобразования величин будем использовать значения, сохраненные в файле `valutes.xml`.

## 2.1 Внешний вид окна

Создадим приложение WPF. Для основного окна зададим свойства:
`Height="800" Width="500" ResizeMode="NoResize"`

В коде окна добавим необходимые элементы:
```xml
<StackPanel Margin="8">
        <Label Content="Конвертер валют" />
        <Label Content="Из: "  />
        <ComboBox  />
        <Label Content="В: "  />
        <ComboBox  />
        <Label Margin="0 50 0 0" Content="Исходная величина:"  />
        <TextBox  />
        <Label Content="Результат"  />
        <TextBox  />
    </StackPanel>
```
![](4.png)

Далее, изменим файл `app.xaml`:
```xml
<Application.Resources>
        <Style TargetType="Label">
            <Setter Property="FontWeight" Value="Medium" />
            <Setter Property="FontSize" Value="20" />
        </Style>
    </Application.Resources>
```
Тэг `Style` позволяет задать стиль какого-либо элемента. Так, в коде выше мы определяем стиль для `Label`. Внутри `Style` могут быть заданы `Setter`, которые позволяют установить значения интересующих нас свойств. В данном случае, используются свойства (`Property`) FontWeight и FontSize. 

После задания стиля `Label` вы сразу же можете увидеть изменения в конструкторе. Зададим другие стили:
```xml
	<Application.Resources>
        <Style TargetType="Label">
            <Setter Property="FontWeight" Value="Medium" />
            <Setter Property="FontSize" Value="20" />
        </Style>
        <Style TargetType="ComboBox">
            <Setter Property="FontSize" Value="20" />
        </Style>
        <Style TargetType="TextBox">
            <Setter Property="FontSize" Value="20" />
        </Style>
    </Application.Resources>
```

Мы задали стили для *всех* элементов соответствующих типов. Однако, возможно, что мы хотим, чтобы одни `Label` имели один стиль, а другие - другой. В этом случае, мы можем определить для стиля некоторый ключ. Создадим стиль для заголовка:
```xml
		<Style x:Key="headerLabel" TargetType="Label">
            <Setter Property="FontSize" Value="28" />
            <Setter Property="FontWeight" Value="Bold"/>
        </Style>
```
Назначим стиль первому `Label`:
```xml
<Label Content="Конвертер валют" Style="{StaticResource headerLabel}" />
```

Результат применения стилей:
![](5.png)

## 2.2 Загрузка значений в ComboBox

Добавим в проект файл `valutes.xml`, разместив его в каталоге `Data`:
![](7.png)

Теперь, создадим класс `Valute`:
![](8.png)
```cs
public class Valute
    {
        public int Code { get; set; }
        public string CharCode { get; set; }
        public int Nominal { get; set; }
        public string Name { get; set; }
        public double Value { get; set; }
    }
```

Также, добавим для загрузки статический класс:
![](9.png)
```cs
    public static class ValuteLoader
    {
        /// <summary>
        /// Получает список валют из текста XML
        /// </summary>
        /// <param name="XMLText">Строка с информацией о валютах в формате XML</param>
        /// <returns>Список валют</returns>
        public static List<Valute> LoadValutes(string XMLText)
        {
            throw new NotImplementedException("самостоятельная работа");
        }
    }
```
Метод `LoadValutes` должен получать на входе строку, а на выходе давать список валют. Реализовать **самостоятельно**.

Загрузим данные из файла:
```cs
	public partial class MainWindow : Window
    {
        private List<Valute> valutes;
        public MainWindow()
        {
            InitializeComponent();
			string xmlText = File.ReadAllText("data/valutes.xml");
            valutes = Data.ValuteLoader.LoadValutes(xmlText);
        }
    }    
```

Назначим всем используемым элементам Name:
```xml
	<StackPanel Margin="8">
        <Label Content="Конвертер валют" Style="{StaticResource headerLabel}" />
        <Label Content="Из: "  />
        <ComboBox x:Name="FromComboBox" />
        <Label Content="В: "  />
        <ComboBox x:Name="ToComboBox" />
        <Label Margin="0 50 0 0" Content="Исходная величина:"  />
        <TextBox x:Name="InputBox" />
        <Label Content="Результат"  />
        <TextBox IsReadOnly="True" x:Name="OutputBox"  />
    </StackPanel>
```

Используем свойства ComboBox `ItemSource` и `DisplayMemberPath`:
```cs
		public MainWindow()
        {
            InitializeComponent();
            string xmlText = File.ReadAllText("data/valutes.xml");
            valutes = Data.ValuteLoader.LoadValutes(xmlText);
            // ItemSource - источник элементов
            FromComboBox.ItemsSource = valutes;
            // DisplayMemberPath - свойство элемента, которое необходимо выводить
            FromComboBox.DisplayMemberPath = "Name";
            ToComboBox.ItemsSource = valutes;
            ToComboBox.DisplayMemberPath = "Name";
        }
```

## 2.2 Преобразование величин

Запретим вводить в поле ввода нечисловые символы. Для этого:
- добавим обработчик события (для входного `TextBox`) `PreviewTextInput="FilterText"`;
- опишем его


```cs
		private void FilterText(object sender, TextCompositionEventArgs e)
        {
            if (!int.TryParse(e.Text, out int x))
            {
                e.Handled = true;
            }
        }
```

Теперь, нужно описать логику преобразования. Добавим обработчик `TextChanged="Calculate"`:
```cs
		private void Calculate(object sender, TextCompositionEventArgs e)
        {

        }
```

Логика преобразования следующая:
- преобразуем первое значение (исходная валюта) в рубли, используя коэффициент перевода (текущий курс);
- из рублей преобразуем в выходную валюту, также используя коэффициент;

```cs
		private void Calculate(object sender, TextChangedEventArgs e)
        {
            Valute inValute = FromComboBox.SelectedItem as Valute;
            Valute outValute = ToComboBox.SelectedItem as Valute;
            if (inValute == null || outValute == null)
            {
                return;
            }

            int value = int.Parse(InputBox.Text);
            double rubles = value * inValute.Value;
            double result = rubles / outValute.Value;

            OutputBox.Text = result.ToString();
        }
```
Или безопасный вариант:
```cs
		private void Calculate(object sender, TextChangedEventArgs e)
        {
            Valute inValute = FromComboBox.SelectedItem as Valute;
            Valute outValute = ToComboBox.SelectedItem as Valute;
            if (inValute == null || outValute == null)
            {
                return;
            }

            int value; 
            bool succ = int.TryParse(InputBox.Text, out value);
            if (!succ) return;

            double rubles = value * inValute.Value;
            double result = rubles / outValute.Value;

            OutputBox.Text = result.ToString();
        }
```

Результат:
![](10.png "" "width:500px")

**Самостоятельно**
- для наглядности, добавьте округление результата до 2 знаков после запятой.
- сделайте так, чтобы в списке появился рубль.

## 2.3 Добавляем номинал

Некоторые валюты имеют номинал 1, некоторые измеряются десятками, сотнями или тысячами. Немного изменим код конструктора:
```cs
		public MainWindow()
        {
            InitializeComponent();
			string xmlText = File.ReadAllText("data/valutes.xml");
            valutes = Data.ValuteLoader.LoadValutes(xmlText);
            valutes.Insert(0, new Valute { Name = "Российский Рубль", Value = 1, CharCode = "RUB" });
            // удалили DisplayMemberPath
            FromComboBox.ItemsSource = valutes;
            ToComboBox.ItemsSource = valutes;
        }
```
Результат:
![](11.png "" "width:500px")

По умолчанию вызывается метод `ToString`, который, в случае, если он не переопределен, возвращает название типа (`Model.Valute`). 

Переопределим метод ToString:
```cs
	public class Valute
    {
        public int Code { get; set; }
        public string CharCode { get; set; }
        public int Nominal { get; set; }
        public string Name { get; set; }
        public double Value { get; set; }

        public override string ToString()
        {
            return $"{Nominal} {Name}";
        }
    }
```

Результат:
![](12.png "" "width:500px")


## 2.4 Загрузка файла из сети
Вы можете получить актуальные курсы валют, обратившись к предоставляемому центробанком сервису:
http://www.cbr.ru/development/sxml/
https://www.cbr.ru/scripts/XML_daily.asp

Чтобы получить необходимые данные, нам необходимо выполнить `GET`-запрос. Для начала, подключим
```cs
using System.Net.Http;
```
Код загрузки текста:
```cs
// конструктор MainWindow
			HttpClient client = new HttpClient();
            var respose = 
                client.GetAsync("https://www.cbr.ru/scripts/XML_daily.asp")
                    .GetAwaiter().GetResult();

            var text = respose.Content.ReadAsStringAsync().GetAwaiter().GetResult();
            valutes = Data.ValuteLoader.LoadValutes(text);
```
Здесь, сперва создается экземпляр `HttpClient`. Данный класс позволяет выполнять различные HTTP-запросы. Далее, с помощью метода `GetAsync` выполняется GET-запрос и сохраняется ответ (response). Затем, берется содержимое ответа (`Content`) в качестве строки. Вызовы `.GetAwaiter().GetResult()` нужны, чтобы вызвать асинхронные методы синхронно.

В результате, все значения для будут подгружены из сети.

**Примечание:**
При использовании `.Net Core` могут возникнуть проблемы с кодировкой. Чтобы их разрешить, необходимо установить сборку (через NuGet) `System.Text.Encoding.CodePages`. После чего, следует зарегистрировать провайдер кодовых страниц, вызвав строку:
```cs
Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
```


**Дополнительно:**
- используя оператор `try`, добейтесь, чтобы в случае, когда невозможно присоединиться, значения загружались из файла;
- каждый раз, после успешной загрузки значений, XML-текст сохраняется в файл, перезаписывая информацию на более актуальную;
- сделайте так, чтобы попытка соединения происходила только в том случае, когда дата, указанная в XML-файле (аттрибут `Date`) не совпадает с сегодняшней датой (нет смысла использовать сеть, если мы имеем в файле актуальные данные).