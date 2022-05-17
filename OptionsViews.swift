//
//  addNote.swift
//  Desafio03
//
//  Created by Thaisa Fujii on 5/9/22.
//

import SwiftUI

struct OptionsViews: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode> // modo generico, tipagem
    @ObservedObject var viewModel: notesViewModel //recebe viewmodel
    @State var title: String = ""
    @State var count: Int = 0
    @State var countDescription: Int = 0
    @State var text: String = ""
    @State var color: Color = Color.black
    @State var colorDescription: Color = Color.black
    @State private var fullText: String = ""
    @State var selectedColor: Color = Color("Color")
    var colors: [Color] = [Color("Color"), Color("Color-1"), Color("Color-2"), Color("Color-3"), Color("Color-4")] // colocar as cores no array
    @State private var disabled = true
    var edit: Note? = nil // elemento optional, alterar para editar
    
    var body: some View {
        ScrollView{
            VStack(spacing: 30){
                VStack(spacing: 10){
                    if let edit = edit{
                        Text("Edit") // possui id
                            .onAppear {
                                title = edit.title
                                fullText = edit.description
                                selectedColor = edit.color
                            }
                        
                    } else {
                        Text("Create") // procurar -> onappear
                    }
                    TextField("Node title", text: $title)
                        .font(Font.headline.weight(.bold))
                    TextField("Note description", text: $fullText)
                }
                .padding(20) // espacamento de dentro pra fora
                .frame(maxWidth: .infinity)
                .background(selectedColor)
                .opacity(8)
                .cornerRadius(15.0)
                
                VStack(alignment: .leading, spacing: 15){
                    
                    Text("Title")
                    TextField("Type your note title", text: $title)
                        .foregroundColor(color)
                    //  .frame(width: 300, height: 50)
                    //  .shadow(color: .black, radius: 3)
                    HStack{
                        Spacer()
                        Text("\(title.count)/20")
                            .foregroundColor(color)
                            .onChange(of: title){ title in
                                let letters = title.trimmingCharacters(in: .whitespaces).count
                                self.count = letters
                                
                                switch letters{
                                case 1..<20:
                                    self.color = .black
                                case 20...:
                                    self.color = .red
                                default:
                                    self.color = .black
                                }
                            }
                    }
                    Text("Description")
                    TextEditor(text: $fullText)
                        .frame(width: 350, height: 100)
                        .shadow(color: .black, radius: 3)
                    HStack{
                        Spacer()
                        Text("\(fullText.count)/200")
                            .foregroundColor(colorDescription)
                            .onChange(of: fullText){ title in
                                let letters = title.trimmingCharacters(in: .whitespaces).count
                                self.countDescription = letters
                                
                                switch letters{
                                case 1..<200:
                                    self.colorDescription = .black
                                case 200...:
                                    self.colorDescription = .red
                                default:
                                    self.colorDescription = .black
                                }
                            }
                    }
                    Text("Color")
                }
                
                HStack{
                    ForEach(colors, id: \.self) { color in
                        Rectangle()
                            .foregroundColor(color)
                            .frame(width: 30, height: 30)
                            .opacity(color == selectedColor ? 0.5 : 1.0)
                            .scaleEffect(color == selectedColor ? 1.1 : 1.0)
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                    
                    Spacer()
                }
                if let edit = edit{
                    HStack{
                        Spacer()
                        Button(action: { delete(at: viewModel.notes.firstIndex(where: { $0.id == edit.id })!)}) {
                            Text("Delete Note")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .padding()
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal){
                HStack{
                    Spacer()
                    // joga as infos pra ultima posicao do array
                    // cria uma nota nova baseado nas escolhas do usuario
                    if let edit = edit{
                        Button{
                            self.mode.wrappedValue.dismiss()
                        }label:{
                            Text("Discard")}
                    }
                    Button{
                        //  notes.append(Note(title: title, description: fullText, color: selectedColor))
                        // pegar o item da lista e colocar na condicao os dados novos
                        if let edit = edit{
                            // verificar se sofreu ou nao alteracao
                            if edit.title != title || edit.description != fullText || edit.color != selectedColor {
                                for index in 0..<viewModel.notes.count{
                                    // alteracao
                                    if edit.id == viewModel.notes[index].id {
                                        viewModel.notes[index].title = title
                                        viewModel.notes[index].description = fullText
                                        viewModel.notes[index].color = selectedColor
                                    }
                                }
                            }
                        } else{
                            
                            let saveNote = (Note(title: title, description: fullText, color: selectedColor))
                            viewModel.notes.append(saveNote)
                        }
                        //volta a tela inicial
                        self.mode.wrappedValue.dismiss()
                    }label:{
                        Text("Save") // PRECISA FAZER ALTERACAO NA HORA DE EDITAR
                    }
                    .disabled(title.isEmpty || title.count >= 20 || fullText.isEmpty || fullText.count >= 200)
                }
            }
        }
    }
    func delete(at index: Int) {
        viewModel.notes.remove(at: index)
    }
}

struct OptionsViews_Previews: PreviewProvider {
    static var previews: some View {
        OptionsViews(viewModel: notesViewModel())
    }
}
