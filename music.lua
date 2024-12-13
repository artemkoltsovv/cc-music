-- Убедитесь, что все подключённые колонки имеют модем!
local speaker = peripheral.find("speaker")

if not speaker then
    print("Колонки не найдены! Подключите хотя бы одну колонку.")
    return
end

-- Функция для воспроизведения аудиофайла
local function playAudio(filename)
    if not fs.exists(filename) then
        print("Файл " .. filename .. " не существует!")
        return
    end

    local file = fs.open(filename, "rb")
    local audioData = file.readAll()
    file.close()

    for _, peripheralName in ipairs(peripheral.getNames()) do
        if peripheral.getType(peripheralName) == "speaker" then
            local speakerPeripheral = peripheral.wrap(peripheralName)
            local decoder = assert(audio.dfpwm.make_decoder())

            for chunk in decoder(audioData, 16 * 1024) do
                speakerPeripheral.playAudio(chunk)
                os.sleep(0) -- Пауза, чтобы колонки успевали обрабатывать данные
            end

            speakerPeripheral.stop()
        end
    end
end

-- Имя файла, который нужно воспроизвести
local musicFile = "music.dfpwm"

print("Воспроизведение " .. musicFile .. "...")
playAudio(musicFile)
print("Воспроизведение завершено.")
