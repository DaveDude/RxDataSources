//
//  RxTableViewSectionedCommandDataSource.swift
//  RxDataSources
//
//  Created by David Weiler-Thiessen on 2020-03-22.
//  Copyright © 2020 Saskatoon Skunkworx. All rights reserved.
//

#if os(iOS) || os(tvOS)
import UIKit
#if !RX_NO_MODULE
import RxSwift
import RxCocoa
#endif

open class RxTableViewSectionedCommandDataSource<Section: IdentifiableSectionModelType>
	: TableViewSectionedDataSource<Section>
	, RxTableViewDataSourceType {
	public typealias Element = SectionedDataSourceCommand<Section>

	open func tableView(_ tableView: UITableView, observedEvent: Event<Element>) {
		Binder(self) { dataSource, element in
			switch element {
			case .append(let section):
				let newSectionIndex = dataSource.sectionModels.count
				dataSource.appendSection(section)
				tableView.insertSections(IndexSet(arrayLiteral: newSectionIndex), with: .fade)
			case let .insert(section, sectionIdentifier):
				if let sectionIndex = dataSource.index(of: sectionIdentifier) {
					dataSource.insertSection(section, at: sectionIndex)
					tableView.insertSections(IndexSet(arrayLiteral: sectionIndex), with: .fade)
				}
			case .load(let sections):
				dataSource.setSections(sections)
				tableView.reloadData()
			case .remove(let section):
				if let sectionIndex = dataSource.index(of: section) {
					dataSource.removeSection(at: sectionIndex)
					tableView.deleteSections(IndexSet(arrayLiteral: sectionIndex), with: .fade)
				}
			case .update(let section):
				if let sectionIndex = dataSource.index(of: section.identity) {
					dataSource.setSection(section, at: sectionIndex)
					tableView.reloadSections(IndexSet(arrayLiteral: sectionIndex), with: .fade)
				}
			}
		}.on(observedEvent)
	}

	private func index(of sectionIdentifier: Section.Identity) -> Int? {
		
		return sectionModels.firstIndex(where: { $0.identity == sectionIdentifier })
	}
}
#endif
