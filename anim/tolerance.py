from manim import *

class Tolerance(Scene):
    def construct(self):
        real_period = 1/(27000000/int(27000000/115200))
        desired_period = 1/115200
        num_of_bits = 9
        shift=800 # by bits
        axes = Axes(
            x_range=[shift*real_period, shift*real_period + num_of_bits*real_period, real_period], y_range=[0, 2, 1], axis_config={"color":BLUE}
        )

        real_labels = VGroup()
        real_lines = VGroup()
        for i in range(num_of_bits):
            t = MathTex(r"T_{" + str(i + shift)+ "}")
            t.set_color(BLUE)
            t.move_to(axes.c2p((i + shift) * real_period, -0.2))
            l = Line(
                start =axes.c2p((i + shift) * real_period, -0.1), end=axes.c2p((i + shift) * real_period, 1.5), color=BLUE
            )
            real_labels.add(t)
            real_lines.add(l)

        dresired_labels = VGroup()
        dresired_lines = VGroup()
        for i in range(num_of_bits):
            t = MathTex(r"T_{" + str(i + shift)+ "}")
            t.set_color(RED)
            t.move_to(axes.c2p((i + shift) * desired_period, 2))
            l = Line(
                start =axes.c2p((i + shift) * desired_period, 2-0.1), end=axes.c2p((i + shift) * desired_period, 0.5), color=RED
            )
            dresired_labels.add(t)
            dresired_lines.add(l)
            

        data_bits = VGroup()
        for i in range(num_of_bits):
            data_bit = Rectangle(color=GREEN, height=.7,
                    width=1.2,
                    )
            data_bit.move_to(axes.c2p((i + shift) * real_period + real_period/2, 1))
            # t.move_to(axes.c2p((i + shift) * real_period, -0.2))
            data_bits.add(data_bit)

        self.add(axes, real_labels, real_lines, dresired_labels, dresired_lines, data_bits)