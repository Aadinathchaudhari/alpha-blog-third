class ArticlesController < ApplicationController

      before_action :set_article, only: [:show, :edit, :update, :destroy] 
      before_action :require_user, except: [:show, :index] 
      before_action :require_same_user, only: [:edit, :update, :destroy]

      def show
            #@article=Article.find(params[:id])
      end    

      def index
        #@articles=Article.all
        @articles= Article.paginate(page: params[:page], per_page: 5)
      end    

      def new 
        @article=Article.new
      end   

      def edit
          #@article=Article.find(params[:id])
      end


      def create
          #render plain: params[:article]
          #@article= Article.new(params.require(:article).permit(:title, :description))
          @article= Article.new(article_params)
          @article.user = current_user
          #render plain=article
        
        if   @article.save
          #redirect_to article_path(@article)
          flash[:notice]="Article was created successfully"
          redirect_to @article
        else 
          render 'new',status: :unprocessable_entity
        end   
      end   

      def update
        #@article =Article.find(params[:id])
        #if  @article.update(params.require(:article).permit(:title, :description))
        if  @article.update(article_params)
          flash[:notice]="Article was updated successfully."
          redirect_to @article
        else
          render 'edit',status: :unprocessable_entity
        end   
      end

      def destroy
        #@article=Article.find(params[:id])
        @article.destroy
        flash[:notice]="Article was deleted successfully"
        redirect_to articles_path
      end   

      private 

      def set_article
        @article=Article.find(params[:id])
      end  

      def article_params
      params.require(:article).permit(:title, :description, category_ids: [])
      end
 
      def require_same_user
          if current_user != @article.user && !current_user.admin?
             flash[:alert] = "you can only edit or delete your own article"
             redirect_to @article
          end  
      end   

  
end    