-- Убедитесь, что все подключённые колонки имеют модем!
local speaker = peripheral.find("speaker")

if not speaker then
    print("Колонки не найдены! Подключите хотя бы одну колонку.")
    return
end

local http = require("http")
local fs = require("fs")

-- Задайте URL для файла, который хотите скачать
local url = "https://www.dropbox.com/scl/fi/li6nma3ayb4e62pqypgez/Prodigy-Diesel-Power.dfpwm?rlkey=8gu5uvhv8ycmsnnq5mhcxzqwz&st=dpib22l8&dl=0"

-- Функция для скачивания файла
local function downloadFile(url, filename)
    local response = http.get(url)
    if response then
        local content = response.readAll()
        fs.open(filename, "w").write(content)
        print("Файл успешно загружен!")
    else
        print("Ошибка при скачивании файла.")
    end
end

-- Скачиваем файл


-- Здесь можно добавить код для обработки файла или работы с ним
-- Но для воспроизведения звука потребуются сторонние программы или устройства


-- Функция для воспроизведения аудиофайла
local function playAudio(filename)
    if not fs.exists(filename) then
        print("Файл " .. filename .. " не существует!")
        return
    end

    local file = fs.open(filename, "rb")
    local audioData = file.readAll()
    file.close()

    local decoder = assert(audio.dfpwm.make_decoder())

    for _, peripheralName in ipairs(peripheral.getNames()) do
        if peripheral.getType(peripheralName) == "speaker" then
            local speakerPeripheral = peripheral.wrap(peripheralName)

            for chunk in decoder(audioData) do
                speakerPeripheral.playAudio(chunk)
                os.sleep(0) -- Пауза, чтобы колонки успевали обрабатывать данные
            end

            speakerPeripheral.stop()
        end
    end
end

downloadFile(url, "music.dfpwm")
-- Имя файла, который нужно воспроизвести
local musicFile = "music.dfpwm"

print("Воспроизведение " .. musicFile .. "...")
playAudio(musicFile)
print("Воспроизведение завершено.")
