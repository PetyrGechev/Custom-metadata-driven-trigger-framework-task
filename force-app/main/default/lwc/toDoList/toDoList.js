import { LightningElement, track } from 'lwc';

export default class ToDoList extends LightningElement {
    todoName = '';
    @track todoTasks = [

        {
            id: 1,
            name: 'Test'
        },

    ]

    newToDoTaskId = this.todoTasks.length;
    newTask = 'task';
    updateNewTask(event) {
        this.newTask = event.detail.value;
        console.log(this.newTask)

    }
    AddNewTaskToTheList() {



        this.todoTasks.push({
            id: this.todoTasks.length + 1,
            name: this.newTask
        });
        console.log(this.todoTasks)
        this.newTask = ''
    }
    onClickDeleteItem(event) {
        let elementToDelete = event.target.name;
        let todoTasks = this.todoTasks;
        let indexTodel;
        for (let index = 0; index < todoTasks.length; index++) {

            if (elementToDelete === todoTasks[index].id) {
                indexTodel = index;
            }
        }
        this.todoTasks.splice(indexTodel, 1);
    }
}