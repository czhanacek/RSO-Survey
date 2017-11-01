class ImportRsoCSV
    include CSVImporter

    model Rso
    
    column :name, as: ["Name"], to:->(name) {name.strip; puts name}
    column :nickname, as: ["Short Name"], to:->(nickname) {nickname.strip}
    column :website, as: ["Website"], to:->(website) {website.strip}
    column :description, as: ["Description"]

    identifier :name
end
