class CategoryController < ApplicationController
    def index
        @categories = Category.all
    end

    def create
        Category.create({title: params[:title], category_group_id: params[:category_group]})
        redirect_to controller: "category", action: "index"
    end

    def new

    end

    def destroy
        Category.find(params[:id]).destroy
        redirect_to controller: "category", action: "index"
    end

    def update
        Category.find(params[:id]).update({title: params[:title], category_group_id: params[:category_group]})
        redirect_to controller: "category", action: "index"
    end

    def edit
        @category = Category.find(params[:id])
        
    end

    def new_category_group

    end

    def index_category_groups

    end

    def edit_category_group
        @category_group = CategoryGroup.find(params[:id])
    end

    def update_category_group
        CategoryGroup.find(params[:id]).update({title: params[:title]})
        redirect_to controller: "category", action: "index_category_groups"
    end


    def create_category_group
        CategoryGroup.create({title: params[:title]})
        redirect_to controller: "category", action: "index_category_groups"
    end

    def destroy_category_group
        CategoryGroup.find(params[:id]).destroy
        redirect_to controller: "category", action: "index"
    end
end
