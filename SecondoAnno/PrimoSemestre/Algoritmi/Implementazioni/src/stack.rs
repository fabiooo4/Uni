pub struct Stack<T> {
    data: Vec<T>,
}

impl<T> Stack<T> {
    pub fn new() -> Self {
        Stack { data: Vec::new() }
    }

    pub fn push(&mut self, item: T) {
        self.data.push(item);
    }

    pub fn pop(&mut self) -> Option<T> {
        self.data.pop()
    }

    pub fn top(&self) -> Option<&T> {
        self.data.last()
    }

    pub fn bottom(&self) -> Option<&T> {
        self.data.first()
    }

    pub fn is_empty(&self) -> bool {
        self.data.is_empty()
    }
}

#[cfg(test)]
#[test]
fn stack_empty() {
    let mut stack: Stack<u32> = Stack::new();
    assert!(stack.is_empty());
    assert_eq!(stack.top(), None);
    assert_eq!(stack.bottom(), None);
    assert_eq!(stack.pop(), None);
}

#[test]
fn stack_char() {
    let mut stack = Stack::new();
    stack.push('c');
    stack.push('i');
    stack.push('a');
    stack.push('o');

    assert!(!stack.is_empty());
    assert_eq!(stack.top(), Some('o').as_ref());
    assert_eq!(stack.bottom(), Some('c').as_ref());
    assert_eq!(stack.pop(), Some('o'));
}

#[test]
fn stack_pop() {
    let mut stack = Stack::new();
    stack.push("Hello");
    stack.push(" World");

    assert!(!stack.is_empty());
    assert_eq!(stack.top(), Some(" World").as_ref());
    assert_eq!(stack.bottom(), Some("Hello").as_ref());
    assert_eq!(stack.pop(), Some(" World"));
    assert_eq!(stack.pop(), Some("Hello"));
    assert_eq!(stack.pop(), None);
}
