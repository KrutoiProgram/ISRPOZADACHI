#Магазин 

Реализуем игрушечную модель продуктового магазина.

## Товар

Для начала заметим, что в любом магазине есть товар:
```cs
class Product
{

}
```

Товар должен иметь наименование и цену (в реальности все конечно же намного сложнее, но для нашего примера ограничемся лишь этими данными):

```cs
class Product
{
	private decimal price;
	private string name;
}
```

Опишем конструктор:
```cs
class Product
{
	private decimal price;
	private string name;
	
	public Product(string Name, decimal Price)
	{
		name = Name;
		price = Price;
	}
}
```

Создадим метод, который бы возвращал информацию о товаре:
```cs
class Product
{
	private decimal price;
	private string name;
	
	public Product(string Name, decimal Price)
	{
		name = Name;
		price = Price;
	}
	
	// прим. можно упростить до выражения, используя =>
	public string GetInfo()
	{
		return $"Наименование: {name}; Цена: {price}";
	}
}
```

Попробуем создать товары внутри основного метода `Main` и вывести информацию:
```cs
    class Program
    {
        static void Main(string[] args)
        {
            Product cola = new Product("Кола", 85);
            Product juice = new Product("Сок \"Добрый\"", 100);
            Console.WriteLine(cola.GetInfo());
            Console.WriteLine(juice.GetInfo());
        }
    }
```
Если все было сделано правильно, то вы увидете информацию о созданных товарах.

## Магазин

Товар будем размещать в магазине:
```cs
class Shop
{
	private List<Product> products;
	
	public Shop()
	{
		products = new List<Product>();
	}
}
```

Для этого создадим специальный метод:
```cs
class Shop
{
	private List<Product> products;
	
	public Shop()
	{
		products = new List<Product>();
	}
	
	public void AddProduct(Product product)
	{
		products.Add(product);
	}
}
```

Также добавим метод:
```cs
        public void WriteAllProducts()
        {
            Console.WriteLine("Список продуктов: ");
            foreach (var product in products)
            {
                Console.WriteLine(product.GetInfo());
            }
        }
```

Проверим работоспособность:
```cs
        static void Main(string[] args)
        {
            Product cola = new Product("Кола", 85);
            Product juice = new Product("Сок \"Добрый\"", 100);
            Shop pyaterochka = new Shop();
            pyaterochka.AddProduct(cola);
            pyaterochka.AddProduct(juice);
            pyaterochka.WriteAllProducts();
        }
```

### Небольшое улучшение

На самом деле не очень удобно каждый раз *отдельно* создавать товар и добавлять его:
```cs
Product stuff = new Product("какая-то штука");
myShop.Add(stuff);
```

Добавим еще один метод `CreateProduct`, который бы сразу создавал товар и добавлял его в список:
```cs
        public void CreateProduct(string name, decimal price)
        {
            Product product = new Product(name, price);
            products.Add(product);
        }
```
ИЛИ
```cs
        public void CreateProduct(string name, decimal price)
        {
            products.Add(new Product(name, price));
        }
```

Проверим работоспособность:
```cs
        static void Main(string[] args)
        {
            Shop pyaterochka = new Shop();
            pyaterochka.CreateProduct("Кола", 85);
            pyaterochka.CreateProduct("Сок \"Добрый\"", 100);
            pyaterochka.WriteAllProducts();
        }
```

## Количество

Внесем изменения, чтобы стало возможным учитывать наличие товаров. Для этого заменим список словарем:
```cs
private Dictionary<Product, int> products;
```
Ключом словаря будет продукт, значением - количество товаров.

Новый конструктор:
```cs
        public Shop()
        {
            products = new Dictionary<Product, int>();
        }
```

Изменения в методах:
```cs
        public void AddProduct(Product product, int count)
        {
            products.Add(product, count);
        }

        public void CreateProduct(string name, decimal price, int count)
        {
            products.Add(new Product(name, price), count);
        }

        public void WriteAllProducts()
        {
            Console.WriteLine("Список продуктов: ");
            foreach (var product in products)
            {
                Console.WriteLine(product.Key.GetInfo() + "; Количество: " + product.Value);
            }
        }
```

Проверка работоспособности:
```cs
        static void Main(string[] args)
        {
            Shop pyaterochka = new Shop();
            pyaterochka.CreateProduct("Кола", 85, 200);
            pyaterochka.CreateProduct("Сок \"Добрый\"", 100, 50);
            pyaterochka.WriteAllProducts();
        }
```

## Покупка товаров

Реализуем покупку товара, для этого реализуем метод `Sell` (*для кого-то купить, а для магазина - продать!*)
```cs
        public void Sell(Product product)
        {
            if (products.ContainsKey(product))
            {
                if (products[product] == 0)
                {
                    Console.WriteLine("Нет в наличии!");
                }
                else
                {
                    products[product]--;
                }
            }
			else
			{
				Console.WriteLine("Товар не найден!");
			}
        }
```

Идея алгоритма:
```
если словарь содержит ключ, равный переданному товару, то
	если количество таких товаров == 0, то
		вывод(НЕТ В НАЛИЧИИ)
	иначе
		уменьшить количество товаров на 1
иначе
	вывод(ТОВАР НЕ НАЙДЕН)
```

Реализуем поиск товара по имени. Для этого мы сперва внесем изменения в класс `Product`, сделав поля свойствами:
```cs
    class Product
    {
        public decimal Price { get; set; }
        public string Name { get; set; }

        public Product(string Name, decimal Price)
        {
            this.Name = Name;
            this.Price = Price;
        }

        public string GetInfo()
        {
            return $"Наименование: {Name}; Цена: {Price} руб.";
        }
    }
```

Код метода (внутри `Shop`):
```cs
        public Product FindByName(string name)
        {
            foreach (var product in products.Keys)
            {
                if (product.Name == name)
                {
                    return product;
                }
            }
            return null;
        }
```

Проверка работоспособности:
```cs
        static void Main(string[] args)
        {
            Shop pyaterochka = new Shop();
            pyaterochka.CreateProduct("Кола", 85, 200);
            pyaterochka.CreateProduct("Сок \"Добрый\"", 100, 50);
            pyaterochka.WriteAllProducts();
            Product toSell = pyaterochka.FindByName("Кола");
            pyaterochka.Sell(toSell);
            pyaterochka.WriteAllProducts();
        }
```

### Небольшое улучшение

На самом деле не очень удобно *всегда* сперва вызывать метод для поиска, а потом метод для продажи. Хотелось бы выполнять продажу одной строчкой. Для этого добавим перегрузку метода `Sell`:
```cs
        public void Sell(string ProductName)
        {
            Product ToSell = FindByName(ProductName);
            if (ToSell != null)
            {
                this.Sell(ToSell);
            }
            else
            {
                Console.WriteLine("Товар не найден!");
            }
        }
```

В `Main` имеем:
```cs
        static void Main(string[] args)
        {
            Shop pyaterochka = new Shop();
            pyaterochka.CreateProduct("Кола", 85, 200);
            pyaterochka.CreateProduct("Сок \"Добрый\"", 100, 50);
            pyaterochka.WriteAllProducts();
            pyaterochka.Sell("Кола");
            pyaterochka.WriteAllProducts();
        }
```

## Идеи для развития (опционально)

* Сделать продажу нескольких товаров
* Добавить "прибыль" магазина (при создании равна нулю, при продаже увеличивается на стоимость товара)
* что-нибудь еще, фантазия не ограничена