require 'json'
require 'rexml/document' # Для XML
require 'open3'
require 'zip'            # Для ZIP

# Путь до рабочего стола в зависимости от ОС
desktop_path = if RUBY_PLATFORM =~ /darwin/
                 File.join(Dir.home, 'Desktop')
               elsif RUBY_PLATFORM =~ /linux/
                 File.join(Dir.home, 'Desktop')
               elsif RUBY_PLATFORM =~ /mswin|mingw/
                 File.join(ENV['USERPROFILE'], 'Desktop')
               else
                 puts 'Неизвестная операционная система.'
                 exit
               end

# Функция для отображения доступных дисков
def list_drives
  puts "Доступные диски и их использование:"
  
  output = if RUBY_PLATFORM =~ /darwin/
             `df -h | grep -v Filesystem`
           elsif RUBY_PLATFORM =~ /linux/
             `df -h | grep -v Filesystem`
           elsif RUBY_PLATFORM =~ /mswin|mingw/
             `wmic logicaldisk get size,freespace,caption`
           else
             puts "Неизвестная операционная система."
             return
           end

  puts output.empty? ? "Нет доступных дисков." : output
end

def zip_operations(desktop_path)
  puts "Работа с ZIP"
  puts "1. Создать ZIP файл"
  puts "2. Извлечь ZIP файл"
  puts "3. Удалить ZIP файл"

  print "Выберите действие: "
  zip_action = gets.chomp.to_i

  case zip_action
  when 1
    print "Введите имя ZIP файла (например, archive.zip): "
    zip_name = gets.chomp
    print "Введите имя файла для добавления в ZIP: "
    file_to_zip = gets.chomp

    if File.exist?(file_to_zip)
      Zip::File.open("#{desktop_path}/#{zip_name}", Zip::File::CREATE) do |zipfile|
        zipfile.add(File.basename(file_to_zip), file_to_zip)
      end
      puts "ZIP файл #{zip_name} создан на рабочем столе."
    else
      puts "Файл #{file_to_zip} не найден."
    end
  when 2
    print "Введите имя ZIP файла для извлечения: "
    zip_name = gets.chomp
    zip_file_path = "#{desktop_path}/#{zip_name}"

    if File.exist?(zip_file_path)
      Zip::File.open(zip_file_path) do |zipfile|
        zipfile.each do |entry|
          entry.extract("#{desktop_path}/#{entry.name}")
        end
      end
      puts "ZIP файл #{zip_name} извлечен на рабочий стол."
    else
      puts "ZIP файл #{zip_name} не найден."
    end
  when 3
    print "Введите имя ZIP файла для удаления: "
    zip_name = gets.chomp
    zip_file_path = "#{desktop_path}/#{zip_name}"

    if File.exist?(zip_file_path)
      File.delete(zip_file_path)
      puts "ZIP файл #{zip_name} удален с рабочего стола."
    else
      puts "ZIP файл #{zip_name} не найден."
    end
  else
    puts "Неверный выбор."
  end
end

def text_operations(desktop_path)
  puts "Работа с текстовыми файлами"
  print "Введите имя файла (например, file.txt): "
  file_name = gets.chomp
  file_path = "#{desktop_path}/#{file_name}"

  puts "1. Записать в файл"
  puts "2. Прочитать файл"
  puts "3. Удалить файл"

  print "Выберите действие: "
  action = gets.chomp.to_i

  case action
  when 1
    print "Введите текст для записи в файл: "
    content = gets.chomp
    File.open(file_path, 'w') { |file| file.write(content) }
    puts "Текст записан в файл #{file_name}."
  when 2
    if File.exist?(file_path)
      content = File.read(file_path)
      puts "Содержимое файла #{file_name}:"
      puts content
    else
      puts "Файл #{file_name} не найден."
    end
  when 3
    if File.exist?(file_path)
      File.delete(file_path)
      puts "Файл #{file_name} удален."
    else
      puts "Файл #{file_name} не найден."
    end
  else
    puts "Неверный выбор."
  end
end

def json_operations(desktop_path)
  puts "Работа с JSON"
  print "Введите имя JSON файла (например, data.json): "
  file_name = gets.chomp
  file_path = "#{desktop_path}/#{file_name}"

  puts "1. Записать в JSON файл"
  puts "2. Прочитать JSON файл"
  puts "3. Удалить JSON файл"

  print "Выберите действие: "
  action = gets.chomp.to_i

  case action
  when 1
    print "Введите данные для записи в JSON формате: "
    data = gets.chomp
    File.open(file_path, 'w') { |file| file.write(data) }
    puts "Данные записаны в JSON файл #{file_name}."
  when 2
    if File.exist?(file_path)
      content = File.read(file_path)
      puts "Содержимое JSON файла #{file_name}:"
      puts content
    else
      puts "JSON файл #{file_name} не найден."
    end
  when 3
    if File.exist?(file_path)
      File.delete(file_path)
      puts "JSON файл #{file_name} удален."
    else
      puts "JSON файл #{file_name} не найден."
    end
  else
    puts "Неверный выбор."
  end
end

def xml_operations(desktop_path)
  puts "Работа с XML"
  print "Введите имя XML файла (например, data.xml): "
  file_name = gets.chomp
  file_path = "#{desktop_path}/#{file_name}"

  puts "1. Записать в XML файл"
  puts "2. Прочитать XML файл"
  puts "3. Удалить XML файл"

  print "Выберите действие: "
  action = gets.chomp.to_i

  case action
  when 1
    print "Введите корневой элемент XML: "
    root_element = gets.chomp
    print "Введите вложенный элемент: "
    nested_element = gets.chomp
    print "Введите значение вложенного элемента: "
    value = gets.chomp

    xml_content = REXML::Document.new
    xml_content.add_element(root_element).add_element(nested_element).text = value
    File.open(file_path, 'w') { |file| xml_content.write(file) }
    puts "XML файл #{file_name} создан."
  when 2
    if File.exist?(file_path)
      content = File.read(file_path)
      puts "Содержимое XML файла #{file_name}:"
      puts content
    else
      puts "XML файл #{file_name} не найден."
    end
  when 3
    if File.exist?(file_path)
      File.delete(file_path)
      puts "XML файл #{file_name} удален."
    else
      puts "XML файл #{file_name} не найден."
    end
  else
    puts "Неверный выбор."
  end
end

# Главное меню
loop do
  puts "Выберите действие:"
  puts "1. Вывести доступные диски"
  puts "2. Работа с текстовым файлом"
  puts "3. Работа с JSON"
  puts "4. Работа с XML"
  puts "5. Работа с ZIP"
  puts "6. Выход"

  print "Введите номер действия: "
  action = gets.chomp.to_i

  case action
  when 1
    list_drives
  when 2
    text_operations(desktop_path)
  when 3
    json_operations(desktop_path)
  when 4
    xml_operations(desktop_path)
  when 5
    zip_operations(desktop_path)
  when 6
    puts "Выход из программы."
    exit
  else
    puts "Неверный выбор."
  end
end
