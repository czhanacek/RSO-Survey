class Csv < ApplicationRecord
    mount_uploader :csvfile, CsvUploader
end
