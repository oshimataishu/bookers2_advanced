class BooksController < ApplicationController
  before_action :is_matching_author, only: [:edit, :update]

  def create
    @new_book = current_user.books.new(book_params)
    if @new_book.save
      flash[:notice] = "Book created successfully"
      redirect_to book_path(@new_book)
    else
      @books = Book.all
      render 'books/index'
    end
  end

  def show
    @book = Book.find(params[:id])
    @new_book = Book.new
  end

  def index
    @books = Book.all
    @new_book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "Book updated successfully"
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_author
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
