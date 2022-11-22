## MVPVM showcase

* Similar to MVVM but logic from ViewModel is moved out to Presenter.
* Dummy ViewModel does not need to be tested and can be shared with UI layer without interface.
* ViewModel serves as a separating gateway between UI and CoreApp
* Unidirectional data flow: Presenter -> ViewModel -> View -> Presenter
* Easy to create Mock presentation layer with filled ViewModels 
