//
//  ObservableType+CurrentAndPrevious.swift
//  Corona Light
//
//  Created by iMamad on 12/9/20.
//

import RxSwift

extension ObservableType {
    func currentAndPrevious() -> Observable<(current: Element, previous: Element?)> {
        return self.multicast({ () -> PublishSubject<Element> in PublishSubject<Element>() }) { (values: Observable<Element>) -> Observable<(current: Element, previous: Element?)> in
            let pastValues = values.asObservable().map { previous -> Element? in previous }.startWith(nil)
            return Observable.zip(values.asObservable(), pastValues) { (current, previous) in
                return (current: current, previous: previous)
            }
        }
    }
}
