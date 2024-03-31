class BooksController < ApplicationController
  before_action :is_matching_author, only: [:edit, :update]
  before_action :set_book, only: %i[show edit update destroy]
  before_action :set_new_book, only: %i[show index]

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
    @comment = BookComment.new
  end

  def index
    @books = Book.latest.page(params[:page])
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: 'Book updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book deleted successfully'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def set_new_book
    @new_book = Book.new
  end

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end

  def is_matching_author
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end
end
