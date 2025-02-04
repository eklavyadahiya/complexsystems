# Types of change ---------------------------------------------------------

#First-order change
first_order_change <- data.frame('time' = seq(1, 100, 1), 
                                 'linear' = rep(5, 100),
                                 'constant' = seq(0.1, 10, 0.1),
                                 'exponential' = rep(NA, 100))

for (i in 1:100) {
  first_order_change$exponential[i] <- (0.001 * 1.1 ** i)
}

ggplot(data = first_order_change, aes(x = time)) + 
  geom_line(aes(y = linear, color = 'Linear Value')) + 
  geom_line(aes(y = constant, color = 'Constant Change')) +
  geom_line(aes(y = exponential, color = 'Exponential Change')) +
  xlab('Time') +
  ylab('Value') +
  ggtitle('First-order change')

#Second-order change
second_order_change <- data.frame('time' = seq(1, 100, 1),
                                  'constant' = rep(NA, 100), 
                                  'non-constant' = rep(NA, 100), 
                                  'oscillating' = rep(NA, 100))

for (i in 1:100) {
  second_order_change$constant[i] = sin(i/5) + 6
}


for (i in 1:100) {
  second_order_change$non_constant[i] = sin(i * (i/400)) + 3
}

temp <- c(seq(1, 50, 1), seq(50, 1, -1))

for (i in 1:100) {
  second_order_change$oscillating[i] = cos(temp[i] * temp[i] / 200)
}

ggplot(data = second_order_change, aes(x = time)) + 
  geom_line(aes(y = constant, color = 'Constant Oscillation')) +
  geom_line(aes(y = non_constant, color = 'Non-constant Oscillation')) +
  geom_line(aes(y = oscillating, color = 'Oscillating Oscillation')) +
  xlab('Time') +
  ylab('Value') +
  ggtitle('Second-order change')

#Third-order change
lorenz <- lorenz(sigma = 10, beta = 8/3, rho = 28, start = c(-13, -14, 47), time = seq(0, 50, by = 0.01))

ggplot(data = data.frame(lorenz), aes(x = time, y = x)) + 
  geom_line() +
  xlab('Time') +
  ylab('X value') +
  ggtitle('Third-order change')