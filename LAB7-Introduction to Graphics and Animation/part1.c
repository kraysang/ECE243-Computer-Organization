#include <stdbool.h>
volatile int pixel_buffer_start; // global variable
void plot_pixel(int x, int y, short int line_color);
void swap(int * a, int * b);
void draw_line(int x_begin, int y_begin, int x_end,int y_end,short int line_color);
void clear_screen();

int main(void)
{
    volatile int * pixel_ctrl_ptr = (int *)0xFF203020;
    /* Read location of the pixel buffer from the pixel buffer controller */
    pixel_buffer_start = *pixel_ctrl_ptr;

    clear_screen();
    draw_line(0, 0, 150, 150, 0x001F);   // this line is blue
    draw_line(150, 150, 319, 0, 0x07E0); // this line is green
    draw_line(0, 239, 319, 239, 0xF800); // this line is red
    draw_line(319, 0, 0, 239, 0xF81F);   // this line is a pink color
}

// code not shown for clear_screen() and draw_line() subroutines

void plot_pixel(int x, int y, short int line_color)
{
    *(short int *)(pixel_buffer_start + (y << 10) + (x << 1)) = line_color;
}

void swap(int * a, int * b){
	int temp = *a;
	*a=*b;
	*b=temp;
}

void draw_line(int x_begin, int y_begin, int x_end,int y_end,short int line_color){
	bool is_steep = abs(y_end-y_begin) > abs(x_end-x_begin);
	if(is_steep){
		swap(&x_begin,&y_begin);
		swap(&x_end,&y_end);
	}
	if(x_begin>x_end){
		swap(&x_begin,&x_end);
		swap(&y_begin,&y_end);
	}
	
	int deltax = x_end - x_begin;
	int deltay = abs(y_end - y_begin);
    int error = -(deltax / 2);
    int y = y_begin;
	int y_step;
	
	if(y_begin < y_end){
		y_step = 1;
	}
	else{
		y_step = -1;
	}
	
	for(int x_count = x_begin;x_count <= x_end;x_count++){
		if(is_steep){
			plot_pixel(y,x_count,line_color);
		}
		else{
			plot_pixel(x_count,y,line_color);
		}
		error += deltay;
		if(error>=0){
			y += y_step;
			error = error - deltax;
		}
	}
}

void clear_screen(){
	for(int x=0;x<=320;x++){
		for(int y=0;y<=240;y++){
			plot_pixel(x,y,0x0000);
		}
	}
}
