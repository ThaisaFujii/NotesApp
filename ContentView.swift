//
//  ContentView.swift
//  Desafio03
//
//  Created by Thaisa Fujii on 5/9/22.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = notesViewModel()
  //  @State var savedText: String = ""
    @State var isActive: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView{
                
                VStack{
                    NavigationLink(destination: OptionsViews(viewModel: viewModel), isActive: $isActive, label:{
                        EmptyView()
                    })
                    if viewModel.notes.isEmpty == true{
                        Text("No notes created yet")
                            .fontWeight(.bold)
                        Text("Create your first role using add button")
                        
                    } else {
                    ForEach(viewModel.notes) { note in
                        NavigationLink(destination: OptionsViews(viewModel: viewModel, edit: note), label:{
                            ListNote(notes: note)
                            })
                        }
                    }
                    
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal){
                    HStack{
                        Text("Mine Notes").font(.title).fontWeight(.bold)
                        Spacer()
                        Button{
                            self.isActive = true
                        }label:{
                            Image(systemName: "plus")
                        }
                    }
                }
            }
        }
    }
}


struct ListNote: View{
    var notes: Note
    
    var body: some View{
        VStack(alignment: .leading, spacing: 10){
            Text(notes.title)
                .font(Font.headline.weight(.bold))
                .foregroundColor(.black)
            Text(notes.description)
                .foregroundColor(.black)
                .padding(.trailing)
        }
        .padding(15) // espacamento de dentro pra fora
        .frame(maxWidth: .infinity)
        .background(notes.color)
        .opacity(8)
        .cornerRadius(15.0)
        .padding(10)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
