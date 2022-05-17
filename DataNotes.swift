//
//  DataNotes.swift
//  Desafio03
//
//  Created by Thaisa Fujii on 5/11/22.
//

import SwiftUI

struct Note: Identifiable{
  var id = UUID()
  var title: String
  var description: String
  var color: Color
}

// view reflete a mudanca na variavel

class notesViewModel:ObservableObject { // observa o update do objeto
    @Published var notes: [Note] = []
    
}
