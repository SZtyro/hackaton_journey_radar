import { Component, HostListener, OnInit } from '@angular/core';


@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent implements OnInit {

  mobileView:boolean = false;

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.mobileView = event.target.innerWidth > 576;
  }

  menu = [
    {name: 'Dashboard', icon: 'home', path: 'dashboard'},
  ]

  ngOnInit(): void {
    this.mobileView = window.innerWidth > 576;
  }

  getCurrentPath(): string{
    return location.pathname.slice(1)
  }

  isServeEnabled(): boolean{
    return (location.hostname === 'localhost' || location.hostname === '127.0.0.1')
      && location.port === '4200';
  }

  getDevelopHref(): string{
    return location.href.replace(':8080', ':4200')
  }

}
