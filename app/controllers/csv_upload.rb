class ImportRsoCSV
    include CSVImporter

    model Rso
    
    column :name, as: ["Name"]
    column :nickname, as: ["Short Name"]

    identifier :name
end
